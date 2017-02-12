class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/5.3.14/link-grammar-5.3.14.tar.gz"
  sha256 "4161ff7af5d6297cc97758ed5062fc48cb3e87749f3b8dcd5b2c8ceae216f267"

  bottle do
    sha256 "66101790b948b5263e51db66687cda46c28da529be606e5034a5727a6fd36afd" => :sierra
    sha256 "3bdd18c86f8a755fb4d40402a8e1ffbec0ee6a629eb350275658cb43b579e8fc" => :el_capitan
    sha256 "fcd29aef31a1b7e36a460b4090ad4381b4dfc51dfc0e11dff5b8d4322471a023" => :yosemite
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
