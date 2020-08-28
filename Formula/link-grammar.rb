class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.8.0/link-grammar-5.8.0.tar.gz"
  sha256 "ad65a6b47ca0665b814430a5a8ff4de51f4805f7fb76642ced90297b4e7f16ed"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e38c9f157ec985be94ed5e792442f5d81c00b71d0b84164ed146d8ab3fbb46dd" => :catalina
    sha256 "4e9b86a609145b67983faa850c0918500cdcb1da5ab5f1ecb945cabdc8533b74" => :mojave
    sha256 "391cc292bef0a6eb3b21add8bf427f0fcc0122ec59b41003387df27a1c51803c" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build

  uses_from_macos "sqlite"

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON_LDFLAGS) -module -no-undefined",
      "$(PYTHON_LDFLAGS) -module"
    inreplace "link-grammar/link-grammar.def", "regex_tokenizer_test\n", ""
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-regexlib=c"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
