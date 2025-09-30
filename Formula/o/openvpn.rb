class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.15.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.15.tar.gz"
  sha256 "e35513ee15995e3c71adfd8891b9f33522896c70b3baa2ed9a23c7a42c4d7bde"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e8fcc37e8cf1663a60bd2a828e45845953c3ed4c350dd82e96521fec9180c37b"
    sha256 arm64_sequoia: "3307ef632ab113476a520edcab9bc50ca2901539ff205e2e2e76d4fed47af504"
    sha256 arm64_sonoma:  "3e501aedc1dc2ee77461fd0af0e36426aa0551e0a5dd5b295b81b785cd061cf3"
    sha256 sonoma:        "90822c5b010f1d64ceb4e4de8660f4925caf14386d468e3a80ed3fb717a27b5d"
    sha256 arm64_linux:   "87b5366d804e3e29e68de5405bd8e480e02c2c573ca66c6f2281ce80069b845c"
    sha256 x86_64_linux:  "ba2c4d6ca2615767b12685faa21ef9e03da963f686787796c4c2855c031559e5"
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
