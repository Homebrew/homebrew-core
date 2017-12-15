class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 7
  head "https://github.com/ledger/ledger.git"

  bottle do
    rebuild 1
    sha256 "78eb7a89c983eb7b44e6cb9886f753b45f0d7dca8840f313df3b61b1260784f4" => :high_sierra
    sha256 "399b606ab4739130941d763809510df932d46402f25e8149ccd19d146bacae1f" => :sierra
    sha256 "90381bb4e3d1537d1741d1275f7671a5d3882991f893cca4f7e70ab6f80ab2f7" => :el_capitan
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python", "Build without python support"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "boost-python" if build.with? "python"

  needs :cxx11

  def install
    ENV.cxx11

    flavor = build.with?("debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]
    args << "--python" if build.with? "python"
    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"
    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py" if build.with? "python"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "python", pkgshare/"demo.py" if build.with? "python"
  end
end
