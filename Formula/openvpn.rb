class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.3.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.3.tar.gz"
  sha256 "13b207a376d8880507c74ff78aabc3778a9da47c89f1e247dcee3c7237138ff6"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ff1ebfbf786de0ebe2be96087213a69508d3b606df61b6865a88eb6c0b4a054c"
    sha256 arm64_monterey: "6021779f46cf630f18789de57c61721bb6e4510e5ee4065ca2415978d2f36439"
    sha256 arm64_big_sur:  "47e1ebd23648c186a0591f9d50d78c5f334b4c7e1ee93e97a3552f2171054d82"
    sha256 ventura:        "dc594adad058abafb74513e20a09a7ca264ec307ba11528e6ec2acfe5a6e9875"
    sha256 monterey:       "0bdad52e9e4cd5d91c88a09a8830db0850753a02f4d7fe92e5b459af78a6afe3"
    sha256 big_sur:        "5fb8556e6501159242a97b6d26f1a68f889c3c489f726a40ccd016fbf3eceb90"
    sha256 x86_64_linux:   "7f55d33157e4e865e7c20234cea31a0ab5a9d676b600088797664b4e25da8e9d"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
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
