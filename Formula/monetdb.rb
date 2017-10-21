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
  url "https://www.monetdb.org/downloads/sources/Jul2017-SP1/MonetDB-11.27.5.tar.xz"
  sha256 "871ce08f3c4d9113f50a43fb396892b9c52ae891e8bf16431c80416cac0f6bef"

  bottle do
    sha256 "86298aa85dcc95afe6ee1858a92097154f800f8b8e2624128c15093e6cf46d66" => :high_sierra
    sha256 "d557a98aba92cf4903da6be105616dcff2e2834fb4a451433b833cda389ee664" => :sierra
    sha256 "0424e83c65eff82b0cd4b53a4cf2b800badc3d4fec6ae0cdc3c24fbf5fc2552a" => :el_capitan
    sha256 "cc914fbe74bf59327c268c65cd70fbc7a84b6b734af44e5281bbd5592c2b7924" => :yosemite
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
