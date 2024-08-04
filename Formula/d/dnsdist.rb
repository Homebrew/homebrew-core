class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.6.tar.bz2"
  sha256 "f6c48d95525693fea6bd9422f3fdf69a77c75b06f02ed14ff0f42072f72082c9"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f7f89d8ad3ddc39d685647806e6e7fdc27598d88482d03f6cbe7e8c46fa70086"
    sha256 cellar: :any,                 arm64_ventura:  "f1c2b1824b1d93d70ea9b0f2a4136f2175f07978e3fb2285168f12ed9c91e054"
    sha256 cellar: :any,                 arm64_monterey: "eb84c592e200e31311a0e21d3a2571126254a21df238c2db1264cf99de7a0879"
    sha256 cellar: :any,                 sonoma:         "1ff1e1c1902cf165e9ff4ff2a904f0ce558450a2174162f4587e000dacfaf59b"
    sha256 cellar: :any,                 ventura:        "4b38254b5be1090d4cfc3144c679319a4343a4c32112391d5dbce055095ee4a3"
    sha256 cellar: :any,                 monterey:       "b305717021c135e7ca43b9a92199a486792bf7cb553a0b6adcc2cba52c58b1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeeab87e8d305be4de7b99c159e9422070b47ce4e4bd74e382f97229b6ded5c9"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "tinycdb" => :build # TODO: make runtime dependency when `tinycdb` formula has a shared library
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

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
