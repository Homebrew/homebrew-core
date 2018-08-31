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
    sha256 "986a25a32d9830eae1e1e4a4a636fbfdc47e0b0d105249173ad80e7229b212f8" => :mojave
    sha256 "f6a9a6028655594c2f2283fd61eb7f3011b7d28d1d262e5addde594c0f1032aa" => :high_sierra
    sha256 "1b1faa664924133af82b89628f01d1bf8a86a577cb1ddf939515ac2d9029b911" => :sierra
    sha256 "98ee12501f9fc81cbe6f9b1389850d36e35e66bf1486a50919f9532687d70190" => :el_capitan
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
