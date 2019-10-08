class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.4.7.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.4.7.tar.xz"
  sha256 "a42f53570f669eaf10af68e98d65b531015ff9e12be7a62d9269ea684652f648"
  revision 1

  bottle do
    sha256 "3cfae9f298ad28601667090d00cff92fc4e5c1ee9fa255046f4cd87d14bb6ee4" => :catalina
    sha256 "b19cc37d3a60d37e935e517dd7c34dd1c9474be22139835f1c21d2e6c86896eb" => :mojave
    sha256 "de0cb2e72fc0faaf91aa210e79524648d2e17fc61938ea1c50cb94ad8105b0c2" => :high_sierra
    sha256 "8f596b79f4c8c21ac2f003a395c8643794f86cdaff517bfed0476364fdbccc38" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"

  # Requires tuntap for < 10.10
  depends_on :macos => :yosemite

  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}"
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

  plist_options :startup => true

  def plist; <<~EOS
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
