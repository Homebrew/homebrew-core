class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.4.2/link-grammar-5.4.2.tar.gz"
  sha256 "46dd36d1f96f018c334df096c3fa0472ebd1365b5f7869711035d02dea00f4e4"

  bottle do
    sha256 "a5cf851dca54d1b6f340c4e9ca6bd34115081a7aab792d5f77d2796fcef8a7dc" => :high_sierra
    sha256 "90b6de9ee0484537b18fb44755c3f62384785c6b78b823d51678d7391496bcaf" => :sierra
    sha256 "9cd19eccd485fb6a3874d87c37b5def29d59b06d48f55fd2e2570f45f9dd224b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :ant => :build

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON2_LDFLAGS) -module -no-undefined",
      "$(PYTHON2_LDFLAGS) -module"
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--no-configure"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
