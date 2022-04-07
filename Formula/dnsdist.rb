class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.0.tar.bz2"
  sha256 "78cc72cb0ccf7fb5f3f2fae09c79eda65a5256374da09bb541b735ea6868fc64"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f4abf383019b7d4b1c997c3e038f2062828fb1aa12d695eb22659e8e282b443f"
    sha256 arm64_big_sur:  "4ff84f0cf8a10b451e651ea006546bdfec36fdf698d3a63622fe7ca4858f0e47"
    sha256 monterey:       "5e894fc18509f36360b9bab1968d68047c4d06588c71de5eca9a3d403bfcb763"
    sha256 big_sur:        "dc9df006ad72b5a318d9164960d95d0a839ecb883c7de99ee9f5334e917be1bd"
    sha256 catalina:       "da62f52599b0020709e3f7ea64c9b74f1d9b3fe8750f570c030e98c5e400364d"
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
