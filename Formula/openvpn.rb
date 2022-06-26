class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.7.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.7.tar.gz"
  sha256 "08340a389905c84196b6cd750add1bc0fa2d46a1afebfd589c24120946c13e68"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4d350124b3dc9c7f040d6aed9f32f78218ae543bbc8b2d47d84f1521ced30632"
    sha256 arm64_big_sur:  "5c41d1fd9c0a1a152b0bf39c6bb5a95e60b46ae2223559cc89b32d57ee0c9391"
    sha256 monterey:       "62fd88ba59c32b406e19c964ce270e238d14a92f45d383995c0cd813e8b85cc0"
    sha256 big_sur:        "211ec35af0ed419841feb0d33522938d44c99c41bdcf801a5c9315ccb87e3eb5"
    sha256 catalina:       "84e91f8c12be690f3d761efc190bce65a45c196527b130f3a7f4e84f3141555a"
    sha256 x86_64_linux:   "7f78bd7675bd0d0e39a0521232a21faaa51453171ceff4ae5e385874c59588fe"
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
