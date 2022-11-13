class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.10.0/inadyn-2.10.0.tar.xz"
  sha256 "58ca61afdc0554b63b3eba1265caa1049c783d0ccfdbabc98273266466d8f142"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 arm64_ventura:  "8ad89c6e8dab475e1da9516e4d4d2427ac0748528bf92fc38a43a47a759f753d"
    sha256 arm64_monterey: "ab86c866e6a92554fde495342d4da7a4d8c032fb4b44c448abdc25945f435ea6"
    sha256 arm64_big_sur:  "71be7b114e6e25d062b57849226150bf888b4a726db3678d30dbd995af7ad6a4"
    sha256 monterey:       "1754f3f16bcd8ceed60d9b57221dd039e2e8b67ea7ca1b917fc1839e15324179"
    sha256 big_sur:        "3af6b728008ac2b61216e1029d2b0d87a5271987dbb5bc1162ccade4d2254311"
    sha256 catalina:       "495213b9a22b777d1800606b615307adcb56e439ec1b2378819ec51c9e9cd94b"
    sha256 x86_64_linux:   "dca652db9dffd7b8203bc5fcf21a9609ced6ade3a764bc12532fe1d4e7f241da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
