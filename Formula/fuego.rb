class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "http://fuego.sourceforge.net/"
  url "http://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  version "1.1.SVN"

  head "http://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    revision 1
    sha256 "382067236c46029318388b64b29cd1541befde1dab0c58285b2a34fe2ecf9f87" => :el_capitan
    sha256 "5eee24a4ddfbc59ed557ca653a0298bc951bc48168319fc1be1b5e8729ef8641" => :yosemite
    sha256 "f04d98b00cc30b4152fc72626b48dc3e29f66bdd1ba28d3bb90dedd064a06167" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end
end
