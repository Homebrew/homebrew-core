class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.1/xapian-omega-1.4.1.tar.xz"
  sha256 "d114bb16431adad50f505edadfb4c97aca9657132b239509ff8cf335aff738af"

  bottle do
    sha256 "513cf3679b92be4aa65c3a098323960d53691d0b69f13b846c4e6d0ee762195d" => :sierra
    sha256 "b6db4104b569317cb9ab1dd8b7a8876f4e8902373567b23433150be6905bf772" => :el_capitan
    sha256 "f4830534a3a4803142c6ce5b037955c98b0756bd9c483f435314d0a1dcd6d2ec" => :yosemite
  end

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
