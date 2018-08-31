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
  url "https://www.monetdb.org/downloads/sources/Aug2018/MonetDB-11.31.7.tar.xz"
  sha256 "4ff3dedc647bc70ed22b410ec1e0ff9a77beb09a477feb34da03bb76bb650eb3"

  bottle do
    sha256 "a5cedc359686dc241264ba8a6578e7f355431c1b153118db4dcae099026319b9" => :mojave
    sha256 "7caf8c4e77f69f2408024041854065141b4dea9e061adca5d4c3495e04fe5239" => :high_sierra
    sha256 "89d71131692ffc25a40b97f3dd69aa1d927dc5247eb08783f58a3c90a8e0b0a8" => :sierra
    sha256 "71027fb57ac2e9939457389b90b8a511769e52a5ce84cfffed6a945b7ea7e78e" => :el_capitan
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-r", "Build the R integration module"

  depends_on RRequirement => :optional

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => [:build, :recommended]
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit.
  depends_on "openssl"

  depends_on "unixodbc" => :optional # Build the ODBC driver
  depends_on "geos" => :optional # Build the GEOM module
  depends_on "cfitsio" => :optional

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--with-readline=#{Formula["readline"].opt_prefix}"]

    args << "--disable-rintegration" if build.without? "r"

    system "./configure", *args
    system "make", "install"
  end
end
