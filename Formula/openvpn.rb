class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.2.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.2.tar.xz"
  sha256 "b12743836901f365efaf82ab2493967e1b21c21eb43ce9a8da1002a17c9c1dc8"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5e6986332d574ba7bdc3144396db4f709ab9a63dcdfb6017dcb422dd7497c7b5"
    sha256 big_sur:       "8d7ea075eed8132ff0032e63db26afcae982f1348a524de87290551d1b90f3f0"
    sha256 catalina:      "b44a899e4774a47fd25522cfddd4a28e46df11e796745c5c1bdeffe6e7e2f54c"
    sha256 mojave:        "4b5ea16d5633f96a6009eb964a56d36fd0cc4f84d420a4cae21e13adc55f405d"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"

  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  on_linux do
    depends_on "linux-pam"
    depends_on "net-tools"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}"
    inreplace "sample/sample-plugins/Makefile",
              HOMEBREW_SHIMS_PATH/"mac/super/pkg-config",
              Formula["pkg-config"].opt_bin/"pkg-config"
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", "#{etc}/openvpn"

    (doc/"samples").install Dir["sample/sample-*"]
    (etc/"openvpn").install doc/"samples/sample-config-files/client.conf"
    (etc/"openvpn").install doc/"samples/sample-config-files/server.conf"

    # We don't use mbedtls, so this file is unnecessary & somewhat confusing.
    rm doc/"README.mbedtls"
  end

  def post_install
    (var/"run/openvpn").mkpath
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/openvpn</string>
          <string>--config</string>
          <string>#{etc}/openvpn/openvpn.conf</string>
        </array>
        <key>OnDemand</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>TimeOut</key>
        <integer>90</integer>
        <key>WatchPaths</key>
        <array>
          <string>#{etc}/openvpn</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{etc}/openvpn</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
