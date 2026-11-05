class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.net/community/releases/openvpn-2.7.9.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.9.tar.gz"
  sha256 "c42a6ed892ddfe2d6e3317a5040f19bec5827564affb2fe3f2b3904a94daacb1"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  compatibility_version 1

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "69cb949500b1d337023503f1896a6884e9a488a9d26d243c94713a7521c90746"
    sha256 arm64_tahoe:       "cc8f601e9236eff5f6dfbb1674a1a66960cca78b05984bf6c8da631b0edad613"
    sha256 arm64_sequoia:     "adfd5b55efcd38ad9874a933b782f561d5e499b3b34672372488888e01bbc90d"
    sha256 arm64_linux:       "debf07d6584804b553fb52b2dd65cf91306937d7251f748a92587b461a85e2a3"
    sha256 x86_64_linux:      "46ce7f16c6cf31e3764cd5dd2e9cfb755a6429fe5884ff0b59877d2a5099ef0a"
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
