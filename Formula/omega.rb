class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.11/xapian-omega-1.4.11.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/x/xapian-omega/xapian-omega_1.4.11.orig.tar.xz"
  sha256 "b030c6f15f52bab4ced428720ba3a6508c8281b8001172cbf1643db1e95e71ed"

  bottle do
    sha256 "0aff76c67bcf3033e2ea54a794d93b85531154be66bf88f1b9cb1c5869337ecb" => :mojave
    sha256 "7fb7918a5ffd7bb9641dc939ed792586ddc8dc4985c5c9eb442a2196a93b9dcc" => :high_sierra
    sha256 "53f9899d6a964d8ae8b0de390dec626836aa24a1004d45352dd7746f53af7934" => :sierra
    sha256 "cdba43e3a877484ee608c3c9a55fc96ebf38b17fb78e1bf2f5b84881aed170b8" => :el_capitan
    sha256 "be5b012a19ea29890fac384b2a1ea3ffe96654da8fa65390c8345fa4d6c88900" => :yosemite
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
