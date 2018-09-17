class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.4.6.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.4.6.tar.xz"
  sha256 "4f6434fa541cc9e363434ea71a16a62cf2615fb2f16af5b38f43ab5939998c26"

  bottle do
    sha256 "66f2838be95b48d8198f41d083d2400653bbc3d9f4d26235cc77ac79eb1d4e20" => :mojave
    sha256 "47aff9000b9a23736bec4d1a58cafa8eb1511ffc85043b5eee2124735f073cd2" => :high_sierra
    sha256 "9e23d0e6089f209c7bbac93594107741a1418bd71e65f4047355d1b1b2c71917" => :sierra
    sha256 "6fd9609026d5f56b688f15856f19a5774f868262251cb1c8b6599a11c41a2fa1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"

  # Requires tuntap for < 10.10
  depends_on :macos => :yosemite

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
