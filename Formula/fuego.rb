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
    sha256 "72603b0cc76547a838cadabc8ddd958bd642493364ab3d35eb7f918347c3c4e1" => :high_sierra
    sha256 "0d3274bc3c26894df8b01725486b3c8a66a33dc47e057974bb56b96b64165ab0" => :sierra
    sha256 "0f4eb59a935afffcd4a518d6d04751566ea712ec49906e1bdeea0be194883cde" => :el_capitan
    sha256 "1089ca13694e6774aaeef91ae23e2633b94420c154a9b94e1a45ae281bda3bee" => :yosemite
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
