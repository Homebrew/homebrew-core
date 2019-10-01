class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "http://abook.sourceforge.net/devel/abook-0.6.1.tar.gz"
  sha256 "f0a90df8694fb34685ecdd45d97db28b88046c15c95e7b0700596028bd8bc0f9"
  revision 2
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    sha256 "c1b909e5047e584971993e46ac28956479f1aca7edd28822df6de649fdb17bce" => :mojave
    sha256 "6dd4fd8e2f57239376ccbe02bc606829d0b976b18f94ae6e5204a7d546ae9a04" => :high_sierra
    sha256 "b078b7af5c5fca8c97e693b70a0700ab91d9bed44bdccbf037ed5eb800c32d7b" => :sierra
  end

  depends_on "readline"

  def install
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
