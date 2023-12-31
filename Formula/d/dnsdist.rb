class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.3.tar.bz2"
  sha256 "858323f2ed5181488bb7558fbf4f84ec7198600b070b2c5375d15d40695727f4"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa41a28651a0cee860df1acc4f2ebe778ba084052c9fe02d33597abdd62e6a36"
    sha256 cellar: :any,                 arm64_ventura:  "57c6a0fdeff23df634af6766fc3bc37fe1689ec7eb208dcb0a812895bbe2f501"
    sha256 cellar: :any,                 arm64_monterey: "b6483d3f9c1448c5d2936e07bde3e76fefc84985485614c5df07873832041a0e"
    sha256 cellar: :any,                 sonoma:         "b5ab32087dc3245c5d1a237b47c7f22e6351dd7d6c688231380e77bf811a6bf1"
    sha256 cellar: :any,                 ventura:        "1ccb79ba86b452bc98706f76360911157a2ea885cbaac1190edda3192e28bca5"
    sha256 cellar: :any,                 monterey:       "c916bc3c76cd05e6f78b6ad49cc4be5bf0d53d772a3726bbb313ccd5cbbe9563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67185319d89776c900401b4e7687451338863d7b7e1ccd11d6411ea32c4cee75"
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
