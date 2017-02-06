class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "http://sourceforge.net/projects/lcsgame/"
  url "svn://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  version "4.07.4b"

  head "svn://svn.code.sf.net/p/lcsgame/code/trunk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
