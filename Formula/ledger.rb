class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 11
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "f96d919957452f536cc0787171945dcdd2be0a17dd5eb3c6abe28e4acd2d3856" => :mojave
    sha256 "d38d1eb6a038d8c2bd5c63d65ce680cf0c60bffdb1e31d47850f54fe721d89f0" => :high_sierra
    sha256 "2e5bf5a4325dc7dee5f845bd8cc5df5641a23439f4a0b4302451951e341e7760" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"

  # Upstream fix for boost 1.68, remove with next version
  patch do
    url "https://github.com/ledger/ledger/commit/c18a55f9.diff?full_index=1"
    sha256 "2e652fc4b247b9c7cd482bd07aa57a66fc86597d7a564e6ccf93232700a6c8d8"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # Boost >= 1.67 Python components require a Python version suffix
    inreplace "CMakeLists.txt", "set(BOOST_PYTHON python)",
                                "set(BOOST_PYTHON python27)"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --python
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
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
