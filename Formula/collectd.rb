class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.9.0.tar.bz2"
  sha256 "7b220f8898a061f6e7f29a8c16697d1a198277f813da69474a67911097c0626b"
  revision 3

  bottle do
    sha256 "1699b212dc7bf7b1d9110770a4e055e76004db767c79b757020c1282a526d812" => :mojave
    sha256 "fb01f2cc9c57ed324acf4fc2ef0476abc5401d8ab69b007f28438235f6dc7550" => :high_sierra
    sha256 "e822cfb01127050d22f7300df8343571245e6f40ca9f91c7a0fd3207c43829df" => :sierra
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"
  uses_from_macos "perl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]

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
