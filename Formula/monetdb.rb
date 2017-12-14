class RRequirement < Requirement
  fatal true

  satisfy { which("r") }

  def message; <<~EOS
    R not found. The R integration module requires R.
    Do one of the following:
    - install R
    -- run brew install r or brew cask install r-app
    - remove the --with-r option
    EOS
  end
end

class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jul2017-SP3/MonetDB-11.27.11.tar.xz"
  sha256 "473b2ea245d8fe006aabe5b2ea3924ade0283f46cfd2edf6fce6aa786c191d0b"

  bottle do
    sha256 "b8c38e0b053c589f448b86f7bcc4ba2b22cc4ee6cc759806104b2a45b7d669e7" => :high_sierra
    sha256 "a04f389b14877abe7905df45df092d0069318af75a885c7154c1b85b2428a0a2" => :sierra
    sha256 "67185b1d204514a4cb67692ada2bb2ca1bb00fe25021101e52929fe57333e492" => :el_capitan
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", "Build the JDBC driver"
  option "with-ruby", "Build the Ruby driver"
  option "with-r", "Build the R integration module"

  depends_on RRequirement => :optional

  depends_on "pkg-config" => :build
  depends_on :ant => :build
  depends_on "libatomic_ops" => [:build, :recommended]
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit.
  depends_on "openssl"

  depends_on "unixodbc" => :optional # Build the ODBC driver
  depends_on "geos" => :optional # Build the GEOM module
  depends_on "gsl" => :optional
  depends_on "cfitsio" => :optional
  depends_on "homebrew/php/libsphinxclient" => :optional

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--with-readline=#{Formula["readline"].opt_prefix}"]

    args << "--with-java=no" if build.without? "java"
    args << "--with-rubygem=no" if build.without? "ruby"
    args << "--disable-rintegration" if build.without? "r"

    system "./configure", *args
    system "make", "install"
  end
end
