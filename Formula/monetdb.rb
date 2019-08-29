class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Apr2019/MonetDB-11.33.3.tar.xz"
  sha256 "f69e7312a77407bef2d970e6d8edfc0ca687d5b31c6b4714bd9132fa468a12e9"
  revision 1

  bottle do
    sha256 "3e1d6f987a517234e15ca18e540933431e539a4bf6a0f1367ee006fe94271d95" => :mojave
    sha256 "12b799e3e7e712831162b86a76e211e5d47ea1f3ad00c13fd12ac7bcd03c65e5" => :high_sierra
    sha256 "e97a07781192a08a7b0313716796021248fbb61e29cd2ce4383368112c51e81f" => :sierra
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
