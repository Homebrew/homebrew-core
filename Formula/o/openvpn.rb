class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.net/community/releases/openvpn-2.7.7.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.7.tar.gz"
  sha256 "3ab8f48fd6c26d49ba2333a092433949afdb5c85c0e6a1ff265784fbc04a2463"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1bae7c0655b006def4c74078bc9a810024771e2d51be47315a58fe13500e885"
    sha256 arm64_sequoia: "2f10357d212ac3f726b12a396bc9c86db6fe49b12fbee49e536dd2c0f62bdbf6"
    sha256 arm64_sonoma:  "60ed11ee38371bef178f5f0149e091faa49a2d26f46b5b0d6be540d8ecda63b0"
    sha256 arm64_linux:   "e4a2533e6b352b2bb1898e75654d63e81ac79f3c9e7bd0970e1ee87003904cd5"
    sha256 x86_64_linux:  "f1174cddd97eb11078ebb4195a361c9bfc8fc7f27dd71fc116eb9358c087e9a8"
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
        s.gsub! Superenv.shims_path/"pkg-config", formula_opt_bin("pkgconf")/"pkg-config"
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
