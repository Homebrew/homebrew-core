class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.8.tar.bz2"
  sha256 "f664f73a96a8d7343d32696accb70fd8b1ed4328d73cdb0a627a561d6e2fd99e"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37a81f1a7902b38db901460d51e372a2c2e78f90b14faf87f6f649928c82abd9"
    sha256 cellar: :any,                 arm64_sonoma:  "42b0a9a71b26f98825ee82d5292b81ec78439db91c646f47887fb4a56f368d67"
    sha256 cellar: :any,                 arm64_ventura: "c25bce9c1cd32bd92ff7298c6e4702b2ebb39772859fb3653c151b7e0da53242"
    sha256 cellar: :any,                 sonoma:        "bbb9ee6cdc27310c15fbdfaa1804a405f76fc8a3d9e9e49af90c547f4f75d311"
    sha256 cellar: :any,                 ventura:       "f3ebdd73c4d92ed6af63a66df23d67f3bd08655b6887845d5f39717579c8cb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "befe41fe1ca151f63a3ff433a29a7f59958dcf054238a23e6a07b2b21938c001"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
