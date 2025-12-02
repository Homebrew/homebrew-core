class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.17.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.17.tar.gz"
  sha256 "4cc8e63f710d3001493b13d8a32cf22a214d5e4f71dd37d93831e2fd3208b370"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c19580ce07313ed2e061d11af6aa9c5a0664dd896bbd60ca18ce2f4ec8dec79a"
    sha256 arm64_sequoia: "12e38d1c6cbc14cf92cc3352824ed7b12eea3c35b50280069da12b954a7f5cc4"
    sha256 arm64_sonoma:  "66d1d8c804e784c45e5ad67b731c98a11b9ab3011b208421a2961f07782062a3"
    sha256 sonoma:        "8f7ea018aae30992aa0a26e44f15c59bb3e5593ff9795ef25462ce8df0073617"
    sha256 arm64_linux:   "a2cef1458fe50e10e1ae1f5be47e72b62eeeb76ce77107a137b64395b4f5eac9"
    sha256 x86_64_linux:  "b4ce95e6858ec9a8c9bdc36d716883050af45298a21ed9f2bc0cae70d10e7a21"
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
