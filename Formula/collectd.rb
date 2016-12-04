class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"

  stable do
    url "https://collectd.org/files/collectd-5.6.2.tar.bz2"
    mirror "https://storage.googleapis.com/collectd-tarballs/collectd-5.6.2.tar.bz2"
    sha256 "cc0b4118a91e5369409ced22d1d8a85c1a400098419414160c1839268ecad0c6"
  end

  bottle do
    sha256 "284b968b8da4025a238b880bc71a4dfa3d1efdb738e14142b74e4547330afb88" => :sierra
    sha256 "5d62c3b863f7e6689ad6050ff091ff501afecf20a5d60ff066f2f2f7b514d977" => :el_capitan
    sha256 "43407ca9df8aca1e7796eb9d6646815392f4c532e54e9a1badf65d13744b033e" => :yosemite
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", "Enable Java support"
  option "with-python", "Enable Python support"
  option "with-protobuf-c", "Enable write_riemann via protobuf-c support"
  option "with-debug", "Enable debug support"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "protobuf-c" => :optional
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

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--disable-java" if build.without? "java"
    args << "--enable-python" if build.with? "python"
    args << "--enable-write_riemann" if build.with? "protobuf-c"
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
