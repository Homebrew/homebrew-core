class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.3.tar.bz2"
  sha256 "7eaf6fac2f26565c5d8658d42a213799e05f4d3bc68e7c716e7174df41315886"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2618d623a6a288fcbb58d54ec068917b7191e80a870f6accc0427bc3fe32384"
    sha256 cellar: :any,                 arm64_monterey: "abfa99eee8c4be2d34e9ffd41a84c8e65c6587370da052b77e893b0210388d8a"
    sha256 cellar: :any,                 arm64_big_sur:  "1525cbf43df195c3646f11dd414e9e1c406bd022745f10cbe0db89767cface3d"
    sha256 cellar: :any,                 ventura:        "e808a27eaf447b30beb6bdf7df4966c8e689314f12fada22301ecd7111b271d6"
    sha256 cellar: :any,                 monterey:       "d45fd758a8dc3aa9c5853dda842ac3d73f1b51a915dc23ff20787933b9d532c5"
    sha256 cellar: :any,                 big_sur:        "ee36153f8036513e45a536cf0b5acf442707e42eb5800a430680d185cbd80cbe"
    sha256 cellar: :any,                 catalina:       "3156bb8c2786805c491b7e8b0b9c5bfc241403edd546fbb86df0b70f3999dfc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "601cad64e21633e94fac8e83de349e9306853496539863486c8b272fa03fedab"
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
