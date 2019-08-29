class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Apr2019/MonetDB-11.33.3.tar.xz"
  sha256 "f69e7312a77407bef2d970e6d8edfc0ca687d5b31c6b4714bd9132fa468a12e9"
  revision 1

  bottle do
    sha256 "98754982eb7de2da55d57923901c2b4e888cba24045a63bdf362fb343dbdc8dc" => :mojave
    sha256 "001a6ae3a8cf8c602789403d75f92d7cbcbc18ca223f1a7dc2f80a8e28966151" => :high_sierra
    sha256 "5ae1ba5352b0d8d4eea311e77ca94671446c7d8c977cb3060fb91dbdad2add9c" => :sierra
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
  depends_on "openssl@1.1"
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
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
  end
end
