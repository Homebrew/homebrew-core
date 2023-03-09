class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.1.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.1.tar.gz"
  sha256 "8cbc4fd8ce27b85107b449833c3b30fb05f1ca3c81b46a0ba8658036944266bc"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "69dc018b3a179e25733e578f8b0e5ef739276735f8ac7ffda18ce5cc5e8e1656"
    sha256 arm64_monterey: "bde1352f1d7b7f5e4994423e19e831fa70ccb7f49ebd9b1a017d7a1f8c65b18f"
    sha256 arm64_big_sur:  "2b48cf1ad09c2f244221cfedf9e20d9b78dd2203ddf1846f0202d35eba197af8"
    sha256 ventura:        "a87aa6cb0582f1c92c767f5fab8571c25a3e8fa395e84beebce7fca05c9579fe"
    sha256 monterey:       "cd79db428eca07fcd1c2ac05065652e8218548b1284d92f0f56a50409919e0db"
    sha256 big_sur:        "7a57fde7f9e9c031ece4e08ed8a5ac305798df02777f087806a3edea8a621414"
    sha256 x86_64_linux:   "161f111c6e1f900058dbc640d5b2dede54bfbb07b4ee0db0551df40ea08dd376"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  on_linux do
    depends_on "libcap-ng"
    depends_on "libnl"
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

  service do
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    require_root true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
