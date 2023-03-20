class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.3.1.tar.gz"
  sha256 "c18341020552fa221203afdf0c0eade1bfa9aa4b7e1ab82a0e456c06b56d1ce4"
  license "BSD-3-Clause"
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6f3413f2d7744acb0bd47e8f4f76b8583820ff402bf38d734ad3275937d79ec"
    sha256 cellar: :any,                 arm64_monterey: "8f4e12b945482680ece472ac84e46ae54050b30720a54db051bb32eca7029446"
    sha256 cellar: :any,                 arm64_big_sur:  "feed005bae77fa8c671aca7d15939e8e7f6aee6b897704c1e1bee29fd925d007"
    sha256 cellar: :any,                 ventura:        "998cd8552eddb2b4f78d4639e94be3db548bf107fabce69cf6a9afc1a1115920"
    sha256 cellar: :any,                 monterey:       "aba672590c63e0296eb97414872a2408d4005b3a0ca9dd44f0d59ac00aae627e"
    sha256 cellar: :any,                 big_sur:        "76e1aea98f3a4ca3f3f73e05008a44f4a3db795d3191cb744b74a003a9a22c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02309c63e6a5068a1ee9aa9009563683fb09c24072852dbc30971a883ddc874f"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.11"

  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
      -DUSE_GPGME=1
    ] + std_cmake_args
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
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
  end
end
