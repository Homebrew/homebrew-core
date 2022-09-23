class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.2.tar.bz2"
  sha256 "524bd2bb05aa2e05982a971ae8510f2812303ab4486a3861b62212d06b1127cd"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c827e90dfcfbbf5d4d52590e773358ee4c7196b97ab7d916ebb2c380da626762"
    sha256 cellar: :any,                 arm64_big_sur:  "7012f771ef3b4acf67d36f04a5f1ba7b24946d9d5fd4eccee4723b25769c5279"
    sha256 cellar: :any,                 monterey:       "89158bd4a8ca2167f47dea428d85499c53be7c7516418809858b42614b0e31dd"
    sha256 cellar: :any,                 big_sur:        "478e7a9499fdb58d8c2f747d345d8583799c839016fa8e95c1dc1e75805db9d1"
    sha256 cellar: :any,                 catalina:       "a4fcac8dd50d500555ed537fc940292ddefdb41c83ac9817e821c14dda604401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a429366f85707cb1c93679539c0272809c7904151427526fe1ae7abb4b7738"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  on_linux do
    depends_on "linux-headers@5.16" => :build
  end

  fails_with gcc: "5"

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
