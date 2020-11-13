class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.0.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.0.tar.xz"
  sha256 "029a426e44d656cb4e1189319c95fe6fc9864247724f5599d99df9c4c3478fbd"

  livecheck do
    url :homepage
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "b4d2c905d810562fc11e83c226ed8572386482f1e856e0f8de3e5ff63ee00526" => :catalina
    sha256 "315e55c0f3b2cdbf4c3e8545c98702e1c4eeff20bc37dbf89921389494b3ef54" => :mojave
    sha256 "bb3ce3b1fbbdf51cf5a207d00a1f60d22eb9b98096595fb81c563dffac077c0f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"

  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}"
    inreplace "sample/sample-plugins/Makefile" do |s|
      s.gsub! HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/pkg-config",
              Formula["pkg-config"].opt_bin/"pkg-config"
      s.gsub! HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/sed",
              "/usr/bin/sed"
    end
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
