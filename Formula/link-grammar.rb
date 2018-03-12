class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.4.4/link-grammar-5.4.4.tar.gz"
  sha256 "c1533379dba0d81e3a924445216aa98a5bf3be9974586a68b00071b654fa69b9"

  bottle do
    sha256 "4025f3704790f11ee4cb525d72f532d717f30123163fb6ef8eaff6b8da0b6937" => :high_sierra
    sha256 "a3de28993287d1c994061e0a4990046f5f41697f9e7ed1d2890bea5173497b97" => :sierra
    sha256 "cbf4f52da509512f865c10b75c4b358d906c356cd06f7edcddf5f65453c7715c" => :el_capitan
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
