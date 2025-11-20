class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.16.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.16.tar.gz"
  sha256 "05cb5fdf1ea33fcba719580b31a97feaa019c4a3050563e88bc3b34675e6fed4"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fa7092eb008e7d36a0ff45de0539942ec851c99d1014b99d4422f7755a72825d"
    sha256 arm64_sequoia: "bb2995355cd9e517d2fe31b2af5612787c461e4329a554aaa47feb15ff660d32"
    sha256 arm64_sonoma:  "ed795cbd79ad267632f40c3c0279e901cbed53287540735e277e8028ac3f414f"
    sha256 sonoma:        "cf58fc0655034777ef08bd8cce6abff0ab6bb7121de7649dca2922b32021953a"
    sha256 arm64_linux:   "fd4d9f9a4448e5cd828a863ae3c8d0440c55e2cb6b248f3ee2cf8622417f3c73"
    sha256 x86_64_linux:  "b3d818f3be09ec0ceca56a8562663e0bb3ee88a80b932b6d01d44df3f4bbcb80"
  end

  depends_on "pkgconf" => :build
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
    system "./configure", "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          *std_configure_args
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkgconf"].opt_bin/"pkg-config"
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
