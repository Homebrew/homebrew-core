class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.net/community/releases/openvpn-2.7.8.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.8.tar.gz"
  sha256 "c070d1d2440b5a6fca6c2c68645c98cd492116ac36ef4f0946177115532c8e36"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "bf80f32655cacacc02e0dd8ea1a2d86eefcbd8c0c704b38fe44b42715c57170d"
    sha256 arm64_tahoe:       "ff8af38d97c1780a6c920ca25398d57faf241c0656e251785095d0587deab0fd"
    sha256 arm64_sequoia:     "314c662194890eca6d48e8ce8771e152ceac2403fa119b7e5b10c6c1d231b19c"
    sha256 arm64_linux:       "ae16c8aa3f0fcf557a4bb8478d95624b0b7cb68f5e3dd780050b72f1fef6f03f"
    sha256 x86_64_linux:      "e869adc4eaf43209173c068bc886d5e6e287ec246984b899c896a1b051f8afe8"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@4"
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
