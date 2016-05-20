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

  def install
    # submitted to upstream: https://github.com/OpenTSDB/opentsdb/pull/711
    # pulled to next branch: https://github.com/OpenTSDB/opentsdb/commit/5d0cfa9b4b6d8da86735efeea4856632581a7adb.patch
    # doesn't apply cleanly on this release though
    # mkdir_p is called from in a subdir of build so needs an extra ../ and there is no rule to create $(classes) and
    # everything builds without specifying them as dependencies of the jar.
    inreplace "Makefile.in" do |s|
      s.sub!(/(\$\(jar\): manifest \.javac-stamp) \$\(classes\)/, '\1')
      s.sub!(/(echo " \$\(mkdir_p\) '\$\$dstdir'"; )/, '\1../')
    end

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

    (bin/"start-tsdb.sh").write <<-EOS.undent
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

    system "#{Formula["hbase"].opt_libexec}/bin/start-hbase.sh"
    sleep 2
    system "#{bin}/create_table.sh"
    system "#{Formula["hbase"].opt_libexec}/bin/stop-hbase.sh"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/opentsdb/bin/start-tsdb.sh"

  def plist; <<-EOS.undent
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
    require "socket"

    cp_r (Formula["hbase"].libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
    end

    ENV["HBASE_LOG_DIR"]  = testpath/"logs"
    ENV["HBASE_CONF_DIR"] = testpath/"conf"
    ENV["HBASE_PID_DIR"]  = testpath/"pid"

    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    sleep 2

    system "#{opt_bin}/create_table.sh"

    pid = fork do
      exec("#{opt_bin}/start-tsdb.sh")
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
