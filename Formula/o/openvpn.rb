class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.7.4.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.4.tar.gz"
  sha256 "18db05f3d5eee3663db1914590044e5f96ff5cd47b6e7846c6a350806c23dbce"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "65b71c2861f4b45d3e44e15fb84541d3649ea9e5197187a0b702032b06e602b4"
    sha256 arm64_sequoia: "20ca5074988d9ea5976207d42a70745060a91a0e494ba2199dcf21e839c2150d"
    sha256 arm64_sonoma:  "f90a2ab2e73d3c18ee338ba5d3f003a054669740bca8f00e3274014ab13ccfc9"
    sha256 sonoma:        "e14dd35951c347f614e22994e40a36da2ba0440ba59dc29f4ad7c18cb7c577d9"
    sha256 arm64_linux:   "eb36465f2ce87e1df1610e6f6385e7377dd4c8a29d709e9f5f9954fdc88e7093"
    sha256 x86_64_linux:  "55bd88f9758d78c578fb5f36f2670cb7e1287e91030a52fdcd867d9111183fd2"
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
