class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.1/xapian-omega-1.4.1.tar.xz"
  sha256 "d114bb16431adad50f505edadfb4c97aca9657132b239509ff8cf335aff738af"

  bottle do
    rebuild 1
    sha256 "fee55591a27a11e2df35ba303166ef2e73243bef6e0b52bebcb57cf040131046" => :sierra
    sha256 "68372f77905f65f4b00b8268bea8e2d17e3cfa042b0900de2f8ae58a1b0e55c2" => :el_capitan
    sha256 "24f80ac193fc2f73440e60ff2be3aa8cdcfae9b4134223417b117d7cfb741c00" => :mavericks
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
