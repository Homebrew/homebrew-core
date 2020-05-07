class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "http://abook.sourceforge.net/devel/abook-0.6.1.tar.gz"
  sha256 "f0a90df8694fb34685ecdd45d97db28b88046c15c95e7b0700596028bd8bc0f9"
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    sha256 "8bd83f518b01cdb21cabd04bb9fd28351d571c3bc3dfb44911a2d39532756967" => :catalina
    sha256 "c1b909e5047e584971993e46ac28956479f1aca7edd28822df6de649fdb17bce" => :mojave
    sha256 "6dd4fd8e2f57239376ccbe02bc606829d0b976b18f94ae6e5204a7d546ae9a04" => :high_sierra
    sha256 "b078b7af5c5fca8c97e693b70a0700ab91d9bed44bdccbf037ed5eb800c32d7b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "readline"

  def install
    # fix "undefined symbols" error caused by C89 inline behaviour
    inreplace "database.c", "inline int", "int"

    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end
