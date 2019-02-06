class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2018-SP2/MonetDB-11.31.13.tar.xz"
  sha256 "f9fbf63ed7e6c306868b289c3fda8c3a8b6d3fc6bef589418940b2a21fd7c283"

  bottle do
    sha256 "c289a7faa889c3adf228d183a5310ef7187d679f93fde340d263f4ce3fb835d6" => :mojave
    sha256 "16557092c3c437c8b2cb316c692a1e52b21db6370caf03af060a364b6550184b" => :high_sierra
    sha256 "309eadb339243a3c262115df347685a4111fac62963fea437676db78d4f4d978" => :sierra
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
