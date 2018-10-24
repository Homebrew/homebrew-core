class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 11
  head "https://github.com/ledger/ledger.git"

  bottle do
    rebuild 1
    sha256 "d2c238504e5005df224cd9b4f08c83b9b40d6afe36bf227989b41fc7ecdd909b" => :mojave
    sha256 "5fc114039587b7ae79924097ab60cd8b8e7166b4d4154ebbec3223c9baf4fbc8" => :high_sierra
    sha256 "bdb1698d718fc58741f052504d8c3fe6dcb87b857a8c8322c82ad6dbd54aa48d" => :sierra
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
