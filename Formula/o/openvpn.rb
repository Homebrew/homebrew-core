class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.10.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.10.tar.gz"
  sha256 "1993bbb7b9edb430626eaa24573f881fd3df642f427fcb824b1aed1fca1bcc9b"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1ca7a2b9a8170749aaef335e33acb6ae79c7da896c4f49d5dbd3a514baeb30bb"
    sha256 arm64_ventura:  "59990e5cb668e7eb5651446aaefb6e94032e1c3255091f209cdf722f8157ebf6"
    sha256 arm64_monterey: "e06a5b65e071f0830b0411814b863fcb84afd2bc7209faacdcd61bcbac8a7bfb"
    sha256 sonoma:         "b0a588a489299b5457df0a54d086612003f7d02688cb8fdd52e4b9ec8ca211c3"
    sha256 ventura:        "58059792f2b18785ddbf582019d7e7a0b7935468efb51b95020caff10f39bb28"
    sha256 monterey:       "42f1a85ea488dfba8edbb303f9b561046fe27f59115748f2dae90dcca81092b9"
    sha256 x86_64_linux:   "173596ce931cc44c733ac10a75cb21d3b30644c3105d1d61f2da02e4b5c05fee"
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
