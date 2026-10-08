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
    sha256 arm64_golden_gate: "e64da55e9cb2b051ed1b7b57bf9069c66b7b112a52d5689adcac9010b25f4e65"
    sha256 arm64_tahoe:       "617781d469ce8dc7ef67c6208822aef62b37276eda76e198ca171124f28a43a9"
    sha256 arm64_sequoia:     "c073d831a6179b815366547c7ed690d7492d2a2fbace1e7ebbd45009cac4bba7"
    sha256 arm64_linux:       "121204f16c89fb365c4f344c7108c1e3b0a7e10d0c4c9e702efbfbe41b529656"
    sha256 x86_64_linux:      "4cb1ecd16c12363bb0918e1047961436a4ae6216203b855f9a99f58090516ef6"
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
