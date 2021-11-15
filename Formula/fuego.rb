class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 2
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_monterey: "43988eeddfae34640a7890439ca629123223a3a8c02aa179720b4ce731d438ea"
    sha256 arm64_big_sur:  "57ea9783adb183338f1d50209385b2dd8cebac5bd346b047cf5ab7e7a617030c"
    sha256 monterey:       "c560c92950af060198a37e9e153e0a6ad15f9b46bb1058387ca91a5fcdfb17b8"
    sha256 big_sur:        "4c9e5e90e68912f757e31c6e5fdbc091a456e5a86e0abbc8c5277823b33003e2"
    sha256 catalina:       "3fcaf6036c24d8771fb2bb55a5e697bbb811aa03c37bae887982b96be70a422f"
    sha256 mojave:         "2e8c65ddbcbb76158ab22805982c75940ed1a6eddc033cc157a03bee1364d502"
    sha256 high_sierra:    "7efef5865934cb21cce5a12c7adf39d3c74a86990067220d456e53db69f8861f"
    sha256 sierra:         "828c076fbcd288d4cc2348323497983f78aceb8bd1b607403b13e35fa209a86f"
    sha256 el_capitan:     "e0c9f36a60667bea6757170232cf45caeca7bff3cf75adb4994b3007d0fe6eb9"
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
