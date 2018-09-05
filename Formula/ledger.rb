class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 10
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "6c008f3d4c2e9f7aa754c9000699abb2082efd084607349c07bbeb0f23eadbfb" => :mojave
    sha256 "6e1f061f0d4333c5d00b06ef1ec79173b0f0485818098d6a170e74b8ebdd6537" => :high_sierra
    sha256 "85235b9d9e751e9216b475cc38fa1dc43a8538c18d4fdb918a412ce9c6aadd04" => :sierra
    sha256 "9e28e41459615b80d02f5fa9f2459b7a3f75bd0d4fc0cbb1031b1611fe84c52c" => :el_capitan
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python@2", "Build without python support"

  deprecated_option "without-python" => "without-python@2"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2" => :recommended
  depends_on "boost-python" if build.with? "python@2"

  needs :cxx11

  def install
    ENV.cxx11

    # Boost >= 1.67 Python components require a Python version suffix
    inreplace "CMakeLists.txt", "set(BOOST_PYTHON python)",
                                "set(BOOST_PYTHON python27)"

    flavor = build.with?("debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]
    args << "--python" if build.with? "python@2"
    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"
    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py" if build.with? "python@2"
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

    system "python", pkgshare/"demo.py" if build.with? "python@2"
  end
end
