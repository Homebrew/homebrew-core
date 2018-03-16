class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.4.5.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.4.5.tar.xz"
  sha256 "43c0a363a332350f620d1cd93bb431e082bedbc93d4fb872f758650d53c1d29e"

  bottle do
    sha256 "518d63d63c46511d417a398db9658bf6ed9dbc3ae137b62d26b3b950ff9255da" => :high_sierra
    sha256 "a744b2a3940c33c2811b7ff9c5f2fdca0ceab0ea31bc1695519ccb5f8cb230ad" => :sierra
    sha256 "2d3b53ff36b06d6e81b4daf2832fdb5ad68002499c9b03638e104c08589ab96c" => :el_capitan
  end

  # Requires tuntap for < 10.10
  depends_on :macos => :yosemite

  depends_on "pkg-config" => :build
  depends_on "lzo"
  depends_on "lz4"
  depends_on "openssl"

  resource "pkcs11-helper" do
    url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.22/pkcs11-helper-1.22.tar.bz2"
    sha256 "fbc15f5ffd5af0200ff2f756cb4388494e0fb00b4f2b186712dce6c48484a942"
  end

  def install
    vendor = buildpath/"brew_vendor"

    resource("pkcs11-helper").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{vendor}/pkcs11-helper",
                            "--disable-threading",
                            "--disable-slotevent",
                            "--disable-shared"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", vendor/"pkcs11-helper/lib/pkgconfig"

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
