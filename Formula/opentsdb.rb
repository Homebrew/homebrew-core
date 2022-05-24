class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database"
  homepage "http://opentsdb.net/"
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.4.0/opentsdb-2.4.0.tar.gz"
  sha256 "a2d6a34369612b3f91bf81bfab24ec573ab4118127dc1c0f0ed6fc57318d102c"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "31e57ba38c568eb7a41a6129a55aac5a9b443301578475702cdab5fb891faaa2"
    sha256 cellar: :any_skip_relocation, mojave:      "ec077c13211eac9912661ff0e3e1165162f251c3408fdf36b709e0e98af34aa2"
    sha256 cellar: :any_skip_relocation, high_sierra: "5bcdc828069e124c16e1e6c8b2eb6732d0ef88533c27f60fcbb0bec369aca375"
  end

  deprecate! date: "2020-11-13", because: :does_not_build

  depends_on "gnuplot"
  depends_on "hbase"
  depends_on "lzo"
  depends_on "openjdk@8"

  def install
    system "./configure",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--mandir=#{man}",
           "--sysconfdir=#{etc}",
           "--localstatedir=#{var}/opentsdb"
    system "make"
    bin.mkpath
    (pkgshare/"static/gwt/opentsdb/images/ie6").mkpath
    system "make", "install"

    env = {
      HBASE_HOME:  Formula["hbase"].opt_libexec,
      COMPRESSION: "LZO",
    }
    env = Language::Java.java_home_env("1.8").merge(env)
    create_table = pkgshare/"tools/create_table_with_env.sh"
    create_table.write_env_script pkgshare/"tools/create_table.sh", env
    create_table.chmod 0755

    inreplace pkgshare/"etc/opentsdb/opentsdb.conf", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    etc.install pkgshare/"etc/opentsdb"
    (pkgshare/"plugins/.keep").write ""

    (bin/"start-tsdb.sh").write <<~EOS
      #!/bin/sh
      exec "#{opt_bin}/tsdb" tsd \\
        --config="#{etc}/opentsdb/opentsdb.conf" \\
        --staticroot="#{opt_pkgshare}/static/" \\
        --cachedir="#{var}/cache/opentsdb" \\
        --port=4242 \\
        --zkquorum=localhost:2181 \\
        --zkbasedir=/hbase \\
        --auto-metric \\
        "$@"
    EOS
    (bin/"start-tsdb.sh").chmod 0755

    libexec.mkpath
    bin.env_script_all_files(libexec, env)
  end

  def post_install
    (var/"cache/opentsdb").mkpath
    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    begin
      sleep 2
      system "#{pkgshare}/tools/create_table_with_env.sh"
    ensure
      system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
    end
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/opentsdb/bin/start-tsdb.sh"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>OtherJobEnabled</key>
          <dict>
            <key>#{Formula["hbase"].plist_name}</key>
            <true/>
          </dict>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/start-tsdb.sh</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/opentsdb/opentsdb.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/opentsdb/opentsdb.err</string>
      </dict>
      </plist>
    EOS
  end

  test do
    cp_r (Formula["hbase"].opt_libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub!(/(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>")
      s.gsub!(/(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>")
    end

    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}/tmp"
    ENV["HBASE_LOG_DIR"]  = testpath/"logs"
    ENV["HBASE_CONF_DIR"] = testpath/"conf"
    ENV["HBASE_PID_DIR"]  = testpath/"pid"

    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    begin
      sleep 2

      system "#{pkgshare}/tools/create_table_with_env.sh"

      tsdb_err = "#{testpath}/tsdb.err"
      tsdb_out = "#{testpath}/tsdb.out"
      fork do
        $stderr.reopen(tsdb_err, "w")
        $stdout.reopen(tsdb_out, "w")
        exec("#{bin}/start-tsdb.sh")
      end
      sleep 15

      pipe_output("nc localhost 4242 2>&1", "put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0\n")

      system "#{bin}/tsdb", "query", "1356998000", "1356999000", "sum",
             "homebrew.install.test", "host=webserver01", "cpu=0"
    ensure
      system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
    end
  end
end
