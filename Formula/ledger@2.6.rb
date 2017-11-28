class LedgerAT26 < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v2.6.3.tar.gz"
  sha256 "d5c244343f054c413b129f14e7020b731f43afb8bdf92c6bdb702a17a2e2aa3a"

  bottle do
    cellar :any
    sha256 "e3bef43460afc61bbc8182dd62cb98c06068c863e787147cb2e38186dd1808ab" => :high_sierra
    sha256 "795cae0983cf60a2f920e37c5ce93eece903d105b7482ec82135310d8c4ce37c" => :sierra
    sha256 "7b0e5ba6ae9eafc22c2d7e7f1c037110dc62da74884e35a23cf225afce062273" => :el_capitan
    sha256 "e2d42c404f3f3a0826498fc9d323392021e4ded1c57d08c27f8e2ac22b5450d0" => :yosemite
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugging symbols enabled"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "pcre"
  depends_on "boost"
  depends_on "gmp"
  depends_on "libofx" => :optional
  depends_on :python => :optional

  deprecated_option "debug" => "with-debug"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
    ]

    if build.with? "libofx"
      args << "--enable-ofx"
      # the libofx.h appears to have moved to a subdirectory
      ENV.append "CXXFLAGS", "-I#{Formula["libofx"].opt_include}/libofx"
    end

    args << "--enable-python" if build.with? "python"
    args << "--enable-debug" if build.with? "debug"

    system "./autogen.sh"
    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
    (share+"ledger/examples").install "sample.dat", "scripts"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--file", share/"ledger/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "python", "#{share}/ledger/demo.py" if build.with? "python"
  end
end
