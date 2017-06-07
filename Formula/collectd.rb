class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.7.2.tar.bz2"
  sha256 "9d20a0221569a8d6b80bbc52b86e5e84965f5bafdbf5dfc3790e0fed0763e592"

  bottle do
    rebuild 1
    sha256 "6604660223da27b57b6547e982b62e4a67350a214fa7a7f13ed08d06aa7cf5a5" => :sierra
    sha256 "489870b68d80dd7a9bef6cfefa463da0163573a13547ae14766a45a3de4000aa" => :el_capitan
    sha256 "17008bc89ddf6684f2a941efe848c3412e7e92007e40b812186a5e8af1024537" => :yosemite
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

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "riemann-client" => :optional
  depends_on :java => :optional
  depends_on :python => :optional
  depends_on "net-snmp"

  fails_with :clang do
    build 318
    cause <<-EOS.undent
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
    args << "--enable-python" if build.with? "python"
    args << "--enable-write_riemann" if build.with? "riemann-client"
    args << "--enable-debug" if build.with? "debug"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

  def plist; <<-EOS.undent
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
    begin
      pid = fork { exec sbin/"collectd", "-f" }
      assert shell_output("nc -u -w 2 127.0.0.1 25826", 0)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
