class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.5.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.5.tar.gz"
  sha256 "e34efdb9a3789a760cfc91d57349dfb1e31da169c98c06cb490c6a8a015638e2"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8bbc0fc0eac54e799776419cdf9958f669c46fb550a9b8d865a3efda4afcd962"
    sha256 arm64_monterey: "2324f818dc4c1d6c803a84423bc4a03bb82f17bd2323c4847753450d4a5c4858"
    sha256 arm64_big_sur:  "c3979e83364ca831f333397bed143974c70e4a8f544eafa4075feec14c6d414f"
    sha256 ventura:        "5688988f1132f2b0505626c9a921fe72275234cd3a79a88bf0869a0c46b53aab"
    sha256 monterey:       "8a66be9610feeffdf01a5b576ddd89a1e5fe2996f2202d2c2a5fb897a6e76c6d"
    sha256 big_sur:        "71978a23eec4f0ed94ff147eaadcf48f8cd6085737a9a1205d30f97d1a8f2474"
    sha256 x86_64_linux:   "0e1ee5e55b05a4aba7f452e2da9dfc41a27203e75c9941614eac5eb9e6a546e8"
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
