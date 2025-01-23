class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.13.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.13.tar.gz"
  sha256 "1af10b86922bd7c99827cc0f151dfe9684337b8e5ebdb397539172841ac24a6a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c45316bd8283ceace25beb68ba8176999f03a60102906f9182358fa6344c0371"
    sha256 arm64_sonoma:  "2eb48eca71f0f7110bd76bdcc0c72802ad848a4e89a82a9019a82c1107a1ba75"
    sha256 arm64_ventura: "7dda50d9eac89e49d6ddc98b7fd3f77032d039ee6597d02eb0ef3a189fd4603e"
    sha256 sonoma:        "5921a94223d5cf06907d2d28d650baa55ef863dd744f375c08cf8a3933819be4"
    sha256 ventura:       "5237e55bee12bfc56943f94fda2cd80d24771195ebf804a4cef5b96f68abf883"
    sha256 x86_64_linux:  "06e1f9c2963607e1b108926b296a4a3e8bfa6becc903c2e2a67558d07c7e2c08"
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
