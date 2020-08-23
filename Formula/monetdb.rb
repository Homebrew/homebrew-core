class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2020-SP1/MonetDB-11.37.11.tar.xz"
  sha256 "3cadb3ea42aa6205678dd532756f5e9b6f47650f18463db83f16c8dc55a4325c"

  bottle do
    sha256 "21b3726ec5e83c3ebd0089c0ffba9b612bf282569e46b4b8006d5c1d7da04ca5" => :catalina
    sha256 "e7271dc72a2fbc95257db4d770bd6f2b764a60120d39137cdd0580183f97d2ea" => :mojave
    sha256 "b2b72d85df319b66f74bbfefd3d47ca81ce0a76cd085344a0f9732ece2004451" => :high_sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
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
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system("#{bin}/monetdbd", "create", "#{testpath}/dbfarm")
    assert_predicate testpath/"dbfarm", :exist?
  end
end
