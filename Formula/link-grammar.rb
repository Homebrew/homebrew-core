class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.3.15/link-grammar-5.3.15.tar.gz"
  sha256 "ef3caf0e5d19556de7d51bf3af44e2e374f2835d85fe4ab6b7637b0bb0bae0a5"

  bottle do
    sha256 "f679fa0a6c733f31018f10b495c3207c5cc334853a2f06fd9d464473d2293112" => :sierra
    sha256 "42a771ed7351109fc849de6d6fe4c565bf7889f6c8b67a52c43ead6083d39be5" => :el_capitan
    sha256 "d0eb0b1d6f6f28ba6ac966b7b53a9fbaef0cdc2879400c4b4798300b9cd36ca9" => :yosemite
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
