class HbaseLZORequirement < Requirement
  fatal true

  satisfy(:build_env => false) { Tab.for_name("hbase").with?("lzo") }

  def message; <<-EOS.undent
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
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz"
  sha256 "5689d4d83ee21f1ce5892d064d6738bfa9fdef99f106f45d5c38eefb9476dfb5"

  depends_on "hbase"
  depends_on "lzo" => :recommended
  depends_on HbaseLZORequirement if build.with?("lzo")
  depends_on :java => "1.6+"
  depends_on "gnuplot" => :optional

  # Patch for makefile issue
  # https://github.com/OpenTSDB/opentsdb/pull/711
  patch do
    url "https://github.com/OpenTSDB/opentsdb/commit/5d0cfa9b4b6d8da86735efeea4856632581a7adb.patch"
    sha256 "03593afc905086d2a77d9a1c5e323ddc4b1bc99a0547a3d7e8a97dc1d6e3a229"
  end

  def install
    mkdir "build" do
      system "../configure",
             "--disable-silent-rules",
             "--prefix=#{prefix}",
             "--mandir=#{man}",
             "--sysconfdir=#{etc}",
             "--localstatedir=#{var}/opentsdb"
      system "make"
      bin.mkpath
      system "make", "install-exec-am", "install-data-am"
    end

    env = {
      :HBASE_HOME => Formula["hbase"].opt_libexec,
      :COMPRESSION => (build.with?("lzo") ? "LZO" : "NONE"),
    }
    env = Language::Java.java_home_env.merge(env)
    (bin/"create_table.sh").write_env_script opt_pkgshare/"tools/create_table.sh", env

    inreplace pkgshare/"etc/opentsdb/opentsdb.conf", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    etc.install Dir["#{pkgshare}/etc/opentsdb"]
    (pkgshare/"plugins/.keep").write ""
  end

  def post_install
    (var/"cache/opentsdb").mkpath

    system "#{Formula["hbase"].opt_libexec}/bin/start-hbase.sh"
    sleep 2
    system "#{bin}/create_table.sh"
    system "#{Formula["hbase"].opt_libexec}/bin/stop-hbase.sh"
  end

  def tsdb_args
    %W[
      #{opt_bin}/tsdb
      tsd
      --config=#{HOMEBREW_PREFIX}/etc/opentsdb/opentsdb.conf
      --staticroot=#{HOMEBREW_PREFIX}/opt/opentsdb/share/opentsdb/static/
      --cachedir=#{HOMEBREW_PREFIX}/var/cache/opentsdb
      --port=4242
      --zkquorum=localhost:2181
      --zkbasedir=/hbase
      --auto-metric
    ]
  end

  plist_options :manual => tsdb_args.join(" ")

  def plist
    program_args = tsdb_args.map { |s| "    <string>#{s}</string>" }.join("\n")
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>OtherJobEnabled</key>
        <string>#{Formula["hbase"].plist_name}</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        #{program_args}
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
    require "socket"

    cp_r (Formula["hbase"].libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
    end

    ENV["HBASE_LOG_DIR"]  = (testpath/"logs")
    ENV["HBASE_CONF_DIR"] = (testpath/"conf")
    ENV["HBASE_PID_DIR"]  = (testpath/"pid")

    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    sleep 2

    system "#{opt_bin}/create_table.sh"

    pid = fork do
      exec tsdb_args.join(" ")
    end

    sleep 2

    socket = TCPSocket.new "localhost", 4242
    socket.puts "put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0"
    socket.close

    system "#{bin}/tsdb", "query", "1356998000", "1356999000", "sum", "homebrew.install.test", "host=webserver01", "cpu=0"

    Process.kill(9, pid)

    system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
  end
end
