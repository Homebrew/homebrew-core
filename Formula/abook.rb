class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "http://abook.sourceforge.net/devel/abook-0.6.1.tar.gz"
  sha256 "f0a90df8694fb34685ecdd45d97db28b88046c15c95e7b0700596028bd8bc0f9"
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    sha256 "09e77aa3db2cf8a702effbebbbf83f7a2f860b0d5db6bcf37549edb7db5438a7" => :catalina
    sha256 "a6ab99c751a03e11e2ace660ad9325a9fe4262598f284c0fb87626778383e29d" => :mojave
    sha256 "a0461ecc678e5cb65a901bd39dbd7f0f8015a29ed605e6cf28f1315d5c347ecb" => :high_sierra
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
