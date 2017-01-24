class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/5.3.14/link-grammar-5.3.14.tar.gz"
  sha256 "4161ff7af5d6297cc97758ed5062fc48cb3e87749f3b8dcd5b2c8ceae216f267"

  bottle do
    sha256 "ec7989f26c951c2f90ef0111da713584e0436a5ba87822853b937afbd5b38f73" => :sierra
    sha256 "c32ff21d8c08d02b34f3ec5b337d39dda257ffa8272e4c218363381ce0baf03a" => :el_capitan
    sha256 "f9cace4239ad108604c683e6df1f7d03fefd57c73c416c29c2692861fb0418e3" => :yosemite
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
