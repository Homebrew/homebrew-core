class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/3.1.2.tar.gz"
  sha256 "3ecebe00e8135246e5437e4364bb7a38869fad7c3250b849cf8c18ca2628182e"
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "2e259026690cdf4544bb0d6df7e859c90aeece1986dcb76aca898fa8e88ebd00" => :mojave
    sha256 "9072550d68b9030dbcd0908e954f6fe80a30df0c6e7533fd57ec0cc621593080" => :high_sierra
    sha256 "f19813e2e6b1c942487322c8522c1d8abb17ec77145dbf6cc09d3e1196fc7be0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"

  def install
    ENV.cxx11

    # Fix for https://github.com/ledger/ledger/pull/1760
    # Remove in next version
    inreplace "doc/ledger3.texi", "Getting help, ,",
                                "Getting help, Third-Party Ledger Tutorials,"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --python
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DUSE_PYTHON27_COMPONENT=1
    ]
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py"
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

    system "python", pkgshare/"demo.py"
  end
end
