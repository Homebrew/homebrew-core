class Libsmf < Formula
  desc "C library for handling SMF ('*.mid') files"
  homepage "https://sourceforge.net/projects/libsmf/"
  url "https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz"
  sha256 "d3549f15de94ac8905ad365639ac6a2689cb1b51fdfa02d77fa6640001b18099"
  revision 1

  bottle do
    cellar :any
    sha256 "fa858ef4b6b179d578663bbdb0d5c7490ea75a3921713e577a7f848faa99b601" => :catalina
    sha256 "bbe040e330a998499e078129097a07f2c5de9fff9c5f26a638e6f5248badda3b" => :mojave
    sha256 "7a4b394b51e89bd781fcce0514b3cc58656da63fa2e317186e47828e2c271320" => :high_sierra
    sha256 "45aedd028eb76b2dfbb6fa3ba9b3fc809e7265411d5d7760997a71503ebae41a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
