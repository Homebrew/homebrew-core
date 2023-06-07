class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.4.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.4.tar.gz"
  sha256 "371a2a323a99a79299b9b4caa4a31bc7b2cdff63236e68d429f3ee50e75f3dd4"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fd5f67f820cec1a2d72adf6bc9f3aa2cdfa2a5aec93c806334cb1eb9899be63b"
    sha256 arm64_monterey: "c0450b6f6bff3d8b172c6335c95b715b3e7c22945a7b40c4534c14b4f24e1b6e"
    sha256 arm64_big_sur:  "c7e05104901f1fea6d37b1d5f2bdc0e659dd6c72822954fab5cade875dc09fe5"
    sha256 ventura:        "0f4871505a0ff2e501bfca225a2a8cc1c263985c5c881263a496245bf7de60bb"
    sha256 monterey:       "11832915f08bbf38646a3d563630e51758765a14270837f7a56c0194c1bb3056"
    sha256 big_sur:        "96649d0c7e832bcce41f4e97d54db11e293cef24e3269cfb2a5be128187d8354"
    sha256 x86_64_linux:   "5a213bcf2bf90e01d45bb90081870247a650d537af44bf8abc5d24c08d8b7b49"
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
