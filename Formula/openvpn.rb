class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.6.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.6.tar.gz"
  sha256 "333a7ef3d5b317968aca2c77bdc29aa7c6d6bb3316eb3f79743b59c53242ad3d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3b811d68fcaa1d4b6182a62d4fa45348a7f272286de62e51f02afa7a94267e6b"
    sha256 arm64_big_sur:  "a80b9c439385956d232ede8117645c35438b42027fcfe6b536d36ba4c8e6493f"
    sha256 monterey:       "b3b1f14462a8e24b3112795da85b87d78ef518cf86c387c2b7ebafcb791f8443"
    sha256 big_sur:        "32f3efcc00710d897b795fc4fbbf4294655f05ae79b3c4a1f65af0334028e691"
    sha256 catalina:       "3a6b325ee23a4c85a1faa349b94e1455291e81abbe722655e3799a0db34fcbc4"
    sha256 x86_64_linux:   "9a0181559aff279c019fb8b5caf2d7c3b2eafdbfeecae321f454f6b9cf876fca"
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
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"
      else
        s.gsub! Superenv.shims_path/"ld", "ld"
      end
    end
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", etc/"openvpn"

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
  service do
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
