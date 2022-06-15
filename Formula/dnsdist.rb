class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.2.tar.bz2"
  sha256 "524bd2bb05aa2e05982a971ae8510f2812303ab4486a3861b62212d06b1127cd"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6c46c95fba614f390ed2b8babc6ccd3585e86137169d8a30c5bdfa1225ed2976"
    sha256 arm64_big_sur:  "9b76afad5ceea4840e12dede69fac2226c825369457d6722ef789ce3e05b1b3d"
    sha256 monterey:       "7ec9caaf52e21abd4f9d14e7abb684e6cecd33a56ac9c72cc2c4474f3e01bfd3"
    sha256 big_sur:        "8b08c85b0b88f4d8e61c3d7898b62bf101fde8d05b2b28a1ac04478a0197979f"
    sha256 catalina:       "3d8066131514affbb62ecf7683935fa29c83f3334c9dec5556e259024651c4ff"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
