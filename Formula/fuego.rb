class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 5
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_ventura:  "b312acb9bb04fc31cc2e630ca130e9a7f78d8a4e3f631a83d4a585be80c438be"
    sha256 arm64_monterey: "f6301e86813d55ba476153d0ada58d1cb40791527f59b5cb8c3602426f666a89"
    sha256 arm64_big_sur:  "65dfab9714a6866134dbcd17de0db06148eec4164b00e5dd259ff0fd1732c29d"
    sha256 ventura:        "52dd4347c0f40e9a243a08c1e8811df758604645eb9b55e764da2a1fd61e2937"
    sha256 monterey:       "73d6548393b805dfc42ece561040c1549682cc862a671aa090b32b5f2b2d210e"
    sha256 big_sur:        "73abec7b9dad7cb5bddb944b7ded1f184850543db10c7ed8e4d09ef5f3efbbf1"
    sha256 catalina:       "3df75cc7d8fc3f2975108e15e9a751bbc9b072ab9e4e8355e750a1402bb3526d"
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
    system "make", "install", "LIBS=-lpthread"
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
