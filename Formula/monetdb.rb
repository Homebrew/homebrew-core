class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Nov2019-SP3/MonetDB-11.35.19.tar.xz"
  sha256 "eaca588936532f189e6d3d0be4079f195ee5be20e2f8c5738566b75aa86c8f75"

  bottle do
    sha256 "cae9fb599fc184c773d9b14f25f2e914ea41693562f1ec394e8f764fce425010" => :catalina
    sha256 "6468a9874db95f65c7f607281c9494c5a184fe8d79382e9c4f4f6b4bce353e4a" => :mojave
    sha256 "007f74508914b133980a4eef667ef15e12d6be2245ea028f217431da86ebd5df" => :high_sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

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
    assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
  end
end
