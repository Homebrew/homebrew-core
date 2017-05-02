class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.3/xapian-omega-1.4.3.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/x/xapian-omega/xapian-omega_1.4.3.orig.tar.xz"
  sha256 "2eea0344a0703ba379d845b86d08a9c2e9faf0deb21834d9ea6939b712c6216e"

  bottle do
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
    assert File.exist?("./test/flintlock")
  end
end
