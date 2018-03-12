class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.4.4/link-grammar-5.4.4.tar.gz"
  sha256 "c1533379dba0d81e3a924445216aa98a5bf3be9974586a68b00071b654fa69b9"

  bottle do
    sha256 "e0c5c0dbb3435ebd4e8a1d38952ef86cf5b0ad455815ab06fff397c7386d715c" => :high_sierra
    sha256 "f2f1d0ffcc7dac4d9f24a6592a37e2f98c5e7b846ec6fe74691b1a08b70b00ab" => :sierra
    sha256 "0ff66e42430938c6dd84a669a8e63d1dc1ff29551dc3e4f77c4e7102a376a9fa" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ant" => :build

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON2_LDFLAGS) -module -no-undefined",
      "$(PYTHON2_LDFLAGS) -module"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
