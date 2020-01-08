class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.14/xapian-omega-1.4.14.tar.xz"
  sha256 "8b2b16cd52409c35507d1103cbdf10d9eabd0b5df64d9f34f0c9065a5d0286c3"

  bottle do
    sha256 "9b728b5bbc02212b6f0121db7275f563b5ec69241fceac5129f56e9077ea90f2" => :catalina
    sha256 "bb7b70cb7e9c92e6174226d93483fa1d04f73c47a3da9370231ef0424066054c" => :mojave
    sha256 "b39bad45e77fb4bed15f3c6256604dbd70ea8d757c8825bd4fd245ef8266aaba" => :high_sierra
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
