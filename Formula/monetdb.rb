class RRequirement < Requirement
  fatal true

  satisfy { which("r") }

  def message; <<-EOS.undent
    R not found. The R integration module requires R.
    Do one of the following:
    - install R
    -- run brew install homebrew/science/r or brew install Caskroom/cask/r
    - remove the --with-r option
    EOS
  end
end

class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2016-SP1/MonetDB-11.23.7.zip"
  sha256 "97115a045b3339a534b5e7efd6045dfbc1bdb7a704aeee4200a1336a559f48df"
  revision 1

  bottle do
    sha256 "0e7b7ac672900e479421b9842c84e2095e62b5a2dfb259e2752b78f6bbc87186" => :sierra
    sha256 "05808da840cc2ed418e12b495426a38f1a7d690074020149d1b0298a542a4caa" => :el_capitan
    sha256 "91de84340914919ab0e330ff22d2f115451ca562a9d3c1aa498d66b542cc9f2b" => :yosemite
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
  depends_on "homebrew/science/cfitsio" => :optional
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
