class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.12/xapian-omega-1.4.12.tar.xz"
  sha256 "0e6767d4571b6b58ae4e65b0b60cce57909f11aec245fc557eb9d13a47ca19ce"

  bottle do
    sha256 "48760c990b6cf4e080eb82a00ad789cb85bb465a2494f7b305910f7bbcd60e4a" => :mojave
    sha256 "53caa126a944ec3c6685c5b119c04c242d918993a6602a97122fb7c81c956ae2" => :high_sierra
    sha256 "3eb587feb9c28d3232bd2fb046c95d8b5cc274a90193cdd8ae6bb822a69683bb" => :sierra
  end

  depends_on "libmagic"
  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
