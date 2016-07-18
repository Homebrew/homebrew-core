class Openvpn < Formula
  desc "SSL VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.xz"
  mirror "http://build.openvpn.net/downloads/releases/openvpn-2.3.11.tar.xz"
  sha256 "0f5f1ca1dc5743fa166d93dd4ec952f014b5f33bafd88f0ea34b455cae1434a7"
  revision 1

  bottle do
    cellar :any
    sha256 "7b909e4d3af4fa2a75a8cb7d0fdae13e54bd4be45818e9402468ab0c2ca65704" => :el_capitan
    sha256 "3f8d29088cdf0b171b6b7306780b812da4de6bfdf02065d28fd317b327b80401" => :yosemite
    sha256 "6a64d83068e97d4aa0fb63cacba14630c7c36e5d6e87e8bc5875fbd379d111bf" => :mavericks
  end

  # Requires tuntap for < 10.10
  depends_on :macos => :yosemite

  depends_on "lzo"
  depends_on "openssl"
  depends_on "pkcs11-helper" => [:optional, "without-threading", "without-slotevent"]

  if build.with? "pkcs11-helper"
    depends_on "pkg-config" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-crypto-library=openssl
      --prefix=#{prefix}
      --enable-password-save
    ]

    args << "--enable-pkcs11" if build.with? "pkcs11-helper"

    system "./configure", *args
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", "#{etc}/openvpn"

    (doc/"samples").install Dir["sample/sample-*"]
    (etc/"openvpn").install doc/"samples/sample-config-files/client.conf"
    (etc/"openvpn").install doc/"samples/sample-config-files/server.conf"

    # We don't use PolarSSL, so this file is unnecessary & somewhat confusing.
    rm doc/"README.polarssl"
  end

  def post_install
    (var/"run/openvpn").mkpath
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
    system "#{sbin}/openvpn", "--show-ciphers"
  end
end
