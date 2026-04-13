class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.7.1.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.1.tar.gz"
  sha256 "9858477ec2894a8a672974d8650dcb1af2eeffb468981a2b619f0fa387081167"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40345d22d9df7935fab8953182a85c8893525ec65018edff1112c539735dede9"
    sha256 arm64_sequoia: "f64547169d1732bc351d29dbb743cc3786343889a14f3ba1a3d8f9ab14edf733"
    sha256 arm64_sonoma:  "e6332253270b9c4f27f5ee1171978c580f09ad8a2ddd26b32d5726f87226a310"
    sha256 sonoma:        "50dde1e0f619875d9adb52c3b3dff2e344f7927d6bdf653dda4d3bade19cd43b"
    sha256 arm64_linux:   "1074d91d4d904337c5c32b68c27d148899ef3c9edee649fb9fc59ef0371aa83e"
    sha256 x86_64_linux:  "8605c796ebfebfb2d140d540258d6f2d8f7be398b0a894ae13c3be362c0dfc58"
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
