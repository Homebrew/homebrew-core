class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  else
    url "svn://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  end
  version "1.1.SVN"
  revision 1

  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 "604d629ad7641968eff8a82bf2f1c0893806b2865abffd4da590f1b60c42daf6" => :high_sierra
    sha256 "bd59103de700709dfb35e6447b49ad402aab29538cce5ae32b5b59a33ea5a469" => :sierra
    sha256 "0567d2a70e96691dfa9aa3996a858e3b55577e9c3aa6cf304259476ee1cf6025" => :el_capitan
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

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
