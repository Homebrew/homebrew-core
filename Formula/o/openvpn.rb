class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.10.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.10.tar.gz"
  sha256 "1993bbb7b9edb430626eaa24573f881fd3df642f427fcb824b1aed1fca1bcc9b"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "de1c7075d02ee2516de9d7213bff8d638de3cb99074f14cabe9605f9e9f1e0a2"
    sha256 arm64_ventura:  "d07d251423c07ec8f3ccde7e090fd8d37782a9fbf57c0929f94d64a24b5be9c6"
    sha256 arm64_monterey: "287b05d24718bf36002246998c79054eb1ec5fad08bfd4cbf17e159d0fdbbf3a"
    sha256 sonoma:         "e0e54ef5f82c6ca7e9fd8d2e79ed1d27426dc8d40e5e31fece742fc23f8faf51"
    sha256 ventura:        "9be5ebb1d8845a54e6064b0b096f4a6f72c1b2dab7ab7b974e191876f9c9b618"
    sha256 monterey:       "f9f4eb48313e1faa78e7a1f14ee5b2824566b7df14942a99146a66ff5cd42411"
    sha256 x86_64_linux:   "dcec0b1b2024c92bdad31f4d4668ae915eb3b053967f9c03b76843062e28900d"
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
