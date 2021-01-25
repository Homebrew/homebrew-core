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
    sha256 "8c1dd34477de5532f7ac7c5330d479506ee43276c996b617af77eb14ef7a3d33" => :big_sur
    sha256 "bc491e0a1b9211250e538cff87b5510bcc3f796b17e087862d5c6d129ee99f33" => :arm64_big_sur
    sha256 "918ed747493fb7f709ac2f0be98adace8e9c177b9bc45ff3fd1047ced6700be6" => :catalina
    sha256 "62f20ab70d736ede4a3c58043f6ec1b01a17bb4bba11a71c307eddcccf162bc9" => :mojave
    sha256 "54930a9ae5b2cc1953922802ac7fb3dc5bd8ded10a013de6cd74edb4ba801bbe" => :high_sierra
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
