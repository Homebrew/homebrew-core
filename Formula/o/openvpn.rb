class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.7.2.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.2.tar.gz"
  sha256 "9c3e150a595fc9a375221f2fa9f10524a9c064536cf81c96e3ba66c735b86f26"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "14f3ef7ed3627ec448221048de6ba5997cb2e216532068ac83752ffd52fc1917"
    sha256 arm64_sequoia: "7f74f9c2a3a3389507c0fe333f1f13c2afeae0c1cb535c7ff4f5be7f992675fe"
    sha256 arm64_sonoma:  "58622b4ede751142dc0bb53816e8a84d53f9d931a698d0fdcc5029953913aa6d"
    sha256 sonoma:        "1614faef4bad229237c4a5ba86657bc55cafcf4cec531c20afb6f7dea0010a10"
    sha256 arm64_linux:   "38d646138c561142c663cc75ffb1b7d1079b7cfa8802f47d95b6d98e61cdf96c"
    sha256 x86_64_linux:  "1fddb1485cf9e031df930d3ca621173a19e08d8f04b44397338b7029b0aa4fc0"
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
