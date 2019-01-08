class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2018-SP1/MonetDB-11.31.11.tar.xz"
  sha256 "169f78f6509241e63028adec3f5082fdcf9f8a1ae9d87a59dddf423f8e9f81d5"
  revision 1

  bottle do
    sha256 "df8bdde8ed02b9bd3e7e0aff359824ce363092332ae99c0991eb4a66e942fb22" => :mojave
    sha256 "81fe91062a42037bb497c033e59c1256bffb68e4f3be4c081a9b026b6c3f7162" => :high_sierra
    sha256 "35983a31e38ab40e3bbf9b2f0c557a1b9902842a373ca224e33c805402209b95" => :sierra
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
