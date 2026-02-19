class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.7.0.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.7.0.tar.gz"
  sha256 "2f0e10eb272be61e8fb25fe1cfa20875ff30ac857ef1418000c02290bd6dfa45"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9556ad7724a36ce5c2d015d226ead32d78051f85b795f662d15b0b879a55ab59"
    sha256 arm64_sequoia: "ebf95c77f4a8ac83d50b0a62cb2c5b913a3e594f6ea9c5237776a5f3c242628c"
    sha256 arm64_sonoma:  "27016d74a0169d025635c8e94152f4e46b58a41078a0a6f8dcb0175b46b6a784"
    sha256 sonoma:        "5c8a4352ed57a16917c30709681fd558c77e94760cea767179de28efc532bda5"
    sha256 arm64_linux:   "36b3317cb6d4e11e871fc70c00de6439534c00348da2eca17c81a9b48d8a0e3d"
    sha256 x86_64_linux:  "51ca6876b41a2f3e01b3ba9fc56ad5f464d6e9a611f26bc10fe80198cd04ee4a"
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
