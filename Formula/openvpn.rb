class Openvpn < Formula
  desc "SSL VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.4.1.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.4.1.tar.xz"
  sha256 "fde9e22c6df7a335d2d58c6a4d5967be76df173c766a5c51ece57fd044c76ee5"

  bottle do
    sha256 "9f4d38e20c752064701d6f068af28d90e89614107776b6c8e64ad1d25afedacc" => :sierra
    sha256 "1d1be7da89a42bb4361e1fec916f71c20fc4b4937aa422659c3dd5ba532627a4" => :el_capitan
    sha256 "c663b342985bc14d2d91c85130cd9357499b4ff72b5e031d9b48264867910ce9" => :yosemite
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
    system sbin/"openvpn", "--show-ciphers"
  end
end
