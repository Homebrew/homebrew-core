class HbaseLZORequirement < Requirement
  fatal true

  satisfy(:build_env => false) { Tab.for_name("hbase").with?("lzo") }

  def message; <<~EOS
    hbase must not have disabled lzo compression to use it in opentsdb:
      brew install hbase
      not
      brew install hbase --without-lzo
    EOS
  end
end

class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database."
  homepage "http://opentsdb.net/"
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.3.0/opentsdb-2.3.0.tar.gz"
  sha256 "90e982fecf8a830741622004070fe13a55fb2c51d01fc1dc5785ee013320375a"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbf21f845ccb3f79b9f0a31f44c7581de4f59cfedf62283ea8793d740b74c945" => :high_sierra
    sha256 "4ef2e9151ebc7aafccdeb170495d2a3308ce92f8cbac68cf88c71558d4b8aaf7" => :sierra
    sha256 "0e8eb571054d13d3abcb06940c481814dd54dbb94104cedcdedbd57c09721743" => :el_capitan
    sha256 "07ba3d636bad55c244e259d5eb619f09367f16b3e14e8caea74bbd19c33f44d5" => :yosemite
  end

  depends_on "hbase"
  depends_on :java => "1.6+"
  depends_on "lzo" => :recommended
  depends_on HbaseLZORequirement if build.with?("lzo")
  depends_on "gnuplot" => :optional

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
      :HBASE_HOME => Formula["hbase"].opt_libexec,
      :COMPRESSION => (build.with?("lzo") ? "LZO" : "NONE"),
    }
    env = Language::Java.java_home_env.merge(env)
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

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/opentsdb/bin/start-tsdb.sh"

  def plist; <<~EOS
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
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
    end

    ENV["HBASE_LOG_DIR"]  = testpath/"logs"
    ENV["HBASE_CONF_DIR"] = testpath/"conf"
    ENV["HBASE_PID_DIR"]  = testpath/"pid"

    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    begin
      sleep 2

      system "#{pkgshare}/tools/create_table_with_env.sh"

      tsdb_err = "#{testpath}/tsdb.err"
      tsdb_out = "#{testpath}/tsdb.out"
      tsdb_daemon_pid = fork do
        $stderr.reopen(tsdb_err, "w")
        $stdout.reopen(tsdb_out, "w")
        exec("#{bin}/start-tsdb.sh")
      end
      sleep 15

      begin
        pipe_output("nc localhost 4242 2>&1", "put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0\n")

        system "#{bin}/tsdb", "query", "1356998000", "1356999000", "sum", "homebrew.install.test", "host=webserver01", "cpu=0"
      ensure
        Process.kill(9, tsdb_daemon_pid)
      end
    ensure
      system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
    end
  end
end
