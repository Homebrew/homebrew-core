class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.7.3.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.3.tar.gz"
  sha256 "24f54cb0759330762f1140b874c07c8542c6a08b13457d8570dafd387d49397a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f5d6131643a0253c2afa936e290249969ff8a880406d740715552ae1ed6be68a"
    sha256 arm64_sequoia: "b7ca22d07f8745a243bd9ede5098930876f70c0226c5aff5a7895917cdcf6b55"
    sha256 arm64_sonoma:  "1f343c31ebf790ea3c8d6e864eaf8f63d555d658896ebfce082367ce41a6fc5c"
    sha256 sonoma:        "a74a2c324d975d20c40f60188be7731599619749266db66d2f4cfcd85e6c5abe"
    sha256 arm64_linux:   "ecca033124d764fb47b1bfbc53f15231d3a0dad668835e2d3e38be8c31e3ca14"
    sha256 x86_64_linux:  "5f55b594d45cd0e0946042b6afba9a07dfc8448fddfd42e7ce485a43bb968ed7"
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
