class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4145b5b75bc4620ff914d45d46abd2be7705eb24abc684d4b1be4e10382802f8"
    sha256 cellar: :any,                 arm64_ventura:  "d3db60e10f5052c27d6737658549984667751816dc39ebe0dffed92def247bb9"
    sha256 cellar: :any,                 arm64_monterey: "77309740f48a3df5eb58e5167f1281aaaffdc373ec452b2f7c6d9ad41b83a83e"
    sha256 cellar: :any,                 sonoma:         "da9017774ef1162e8c27a41fa6258b124c553a809be69edd0a679bc7a70df635"
    sha256 cellar: :any,                 ventura:        "b97fcdc2bb9296802d43eff62948ef785ef2b5af10c2e481b2e0e7d2cee5c182"
    sha256 cellar: :any,                 monterey:       "cf1aa84690637896aa285640508418720edd3eec23f070d5b7a654eff83e2fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c121bc47cc61a0e368e65bf4c41eff1e6b0fa1d3335aff5d93582e8498ff4cc"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.12"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  # Support building with mandoc
  # Remove with v3.4.x
  patch do
    url "https://github.com/ledger/ledger/commit/f40cee6c3af4c9cec05adf520fc7077a45060434.patch?full_index=1"
    sha256 "d5be89dbadff7e564a750c10cdb04b83e875452071a2115dd70aae6e7a8ee76c"
  end
  patch do
    url "https://github.com/ledger/ledger/commit/14b90d8d952b40e0a474223e7f74a1e6505d5450.patch?full_index=1"
    sha256 "d250557e385163e3ad3002117ebe985af040d915aab49ae1ea342db82398aeda"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

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
