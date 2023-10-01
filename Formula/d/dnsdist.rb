class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.1.tar.bz2"
  sha256 "05f356fcce29c4ece03c2d8df046adff3aaab0b036d6801c1a311c6d5bb3c07f"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6567d8603c46ea56d43b30893a850beab2a33dd1832e8ff9d626ae99bcfcaa2"
    sha256 cellar: :any,                 arm64_monterey: "66c90a4fa54474502762049e2518053104b2f27a639be59f735948f3048b8d58"
    sha256 cellar: :any,                 arm64_big_sur:  "56f553218cd496f973ca3c361cec4ce6d8a040c71257b09889bd4bc0769252d5"
    sha256 cellar: :any,                 ventura:        "36dfb3549406afa373065447697558c8caa8a6a03747dc0d353178218d17b1c5"
    sha256 cellar: :any,                 monterey:       "2ffe24c8af1194149962378bedf7f9c775487b8ee90a206332e16f14767985cd"
    sha256 cellar: :any,                 big_sur:        "25d87a1306779bb850453b8fbe648be4a2853be4902ccd9eeb0a644f7bbbe186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c423aba005f282e2c79cecb5f758a229a9b722dbabbe52363fa4db4d7b5e13a0"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

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
