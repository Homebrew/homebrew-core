class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.4.2.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.4.2.tar.xz"
  sha256 "df5c4f384b7df6b08a2f6fa8a84b9fd382baf59c2cef1836f82e2a7f62f1bff9"
  revision 1

  bottle do
    sha256 "25f10d0697d4c4c0f94554a118d232dfc996975ffc488d76f57df05152a7e978" => :sierra
    sha256 "d4527016eaf2d60ce7732fd85592e1d3b64d4f33878592b04834b09de5dbe134" => :el_capitan
    sha256 "6a52d439580030f7a2b85e7de7f90fd9f1eaeed09e03f1f202d19a5c614a412d" => :yosemite
  end

  # Requires tuntap for < 10.10
  depends_on :macos => :yosemite

  depends_on "pkg-config" => :build
  depends_on "lzo"
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

    # Install OpenVPN's new contrib helper allowing the use of
    # macOS keychain certificates with OpenVPN.
    cd "contrib/keychain-mcd" do
      system "make"
      sbin.install "keychain-mcd"
      man8.install "keychain-mcd.8"
    end

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
    system sbin/"openvpn", "--show-ciphers"
  end
end
