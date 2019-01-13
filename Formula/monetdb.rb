class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2018-SP1/MonetDB-11.31.11.tar.xz"
  sha256 "169f78f6509241e63028adec3f5082fdcf9f8a1ae9d87a59dddf423f8e9f81d5"
  revision 1

  bottle do
    sha256 "47e2a900b158e95ec44580c381e5bb74798859e1171e60e980e7ca05bbeb5173" => :mojave
    sha256 "5ad55a48403afa11ba67d7429b002ca3c880ed9b19d669fda02905554d2368ce" => :high_sierra
    sha256 "96567ed0d7ed70b80b97dc140f0ca2e05c4bd92af8fa8ef113c485e5e16f901f" => :sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make", "install"
  end
end
