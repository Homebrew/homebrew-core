class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.8.0.tar.bz2"
  sha256 "b06ff476bbf05533cb97ae6749262cc3c76c9969f032bd8496690084ddeb15c9"
  revision 2

  bottle do
    sha256 "c4bca62c6c0b73f7004eceb75fa218a4f8f1d9a0bea09ae8a1b38d4c14663892" => :high_sierra
    sha256 "0e29acd0077f1ad18ee6258b1cd17c407b2ae6ce39b6c8b8c1ecb9c5d9b429c6" => :sierra
    sha256 "0370541be09ba68caed1f335e4a961d6f889f1fc2d30741e7da1aaf5a6fd0b51" => :el_capitan
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", "Enable Java support"
  option "with-python", "Enable Python support"
  option "with-riemann-client", "Enable write_riemann support"
  option "with-debug", "Enable debug support"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"
  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "riemann-client" => :optional
  depends_on :java => :optional
  depends_on "python@2" => :optional
  depends_on "net-snmp"

  fails_with :clang do
    build 318
    cause <<~EOS
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << "--disable-java" if build.without? "java"
    args << "--enable-python" if build.with? "python@2"
    args << "--enable-write_riemann" if build.with? "riemann-client"
    args << "--enable-debug" if build.with? "debug"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
