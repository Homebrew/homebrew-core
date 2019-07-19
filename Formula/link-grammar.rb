class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.6.2/link-grammar-5.6.2.tar.gz"
  sha256 "333c29abdcb6f3b90aff4d24889d11174d45b7cc1960816a257eecd6679186c9"

  bottle do
    sha256 "90b3c98782ea23f109ea0046548c531331f3d07e9645a4d9bd01ae43381c01a0" => :mojave
    sha256 "f201950217bc053f94351992075900a0d6f6d96a22d5411df6ee54e007838762" => :high_sierra
    sha256 "e4103b4f47f143886f2bbfaa089a318921ffb297fedfa0174d0403334375d732" => :sierra
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON2_LDFLAGS) -module -no-undefined",
      "$(PYTHON2_LDFLAGS) -module"
    inreplace "bindings/java/build.xml.in",
      "<property name=\"source\" value=\"1.6\"/>",
      "<property name=\"source\" value=\"1.7\"/>"
    inreplace "bindings/java/build.xml.in",
      "<property name=\"target\" value=\"1.6\"/>",
      "<property name=\"target\" value=\"1.7\"/>"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
