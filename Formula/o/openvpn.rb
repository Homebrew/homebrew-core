class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.net/community/releases/openvpn-2.7.6.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.6.tar.gz"
  sha256 "10e24a9385f23cc38cc5cf448f3ca0769f939bc4cbecc4f4647d7e006e52db74"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7545ba3c3c76b70379e0c955ca481ad081f13445c1828c61122f197bbaa819da"
    sha256 arm64_sequoia: "185ed9da71ec4823134d81fbc28d5496f191dc9f2d8e0281545d2fa859c1b222"
    sha256 arm64_sonoma:  "d8972eb6f5461208f57024ce1100bb1be800e2ab05fc6316b15c3e6a4400f1de"
    sha256 sonoma:        "da147b18605634ccc6b0fed8c28a57ef46928a9086c6fd30ac568b05bdd9b90e"
    sha256 arm64_linux:   "1f2aa19c18173b1aed5632cf6b0cde05bdb61a3d00ae4e1030eba1fdac513819"
    sha256 x86_64_linux:  "d3d45532c2bf7f1f8e43a5514e28d9c245f2bf7b7ee046131923c51c07f042ee"
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
