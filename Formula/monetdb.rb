class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Nov2019-SP1/MonetDB-11.35.9.tar.xz"
  sha256 "7f5b430ef50012cf0db8e5b311d7199978c414d746d1db4e69884e74a86784b0"

  bottle do
    sha256 "3bcbeee039e42de83c8a638df02c0994ccff6c41a5168e6fa5e47dc25d90f09b" => :catalina
    sha256 "12aa7f193f7878b727049bf51a921bf268d0e047dd6ea4256aec708f39fbeb02" => :mojave
    sha256 "272ebf3b3be32e5220c8f155313471da206d3ba681d572026d3fb5dd410e8ada" => :high_sierra
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
