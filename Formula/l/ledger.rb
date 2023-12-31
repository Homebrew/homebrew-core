class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "fa7df3860b42147ac835c5faa41ff67600f8a31b44d716f4958ea531a53e40c3"
    sha256 cellar: :any,                 arm64_ventura:  "0911e597f1426301d7a517ec505cbf4463fefd6c0124c83c260ea0b5397bc358"
    sha256 cellar: :any,                 arm64_monterey: "5a51cb8029ef70278bf3cc451a393137d1ff68d9ccd68d474fe0c2668f4b5956"
    sha256 cellar: :any,                 sonoma:         "866700f0afce17f4cd9728e961a10e7b6fd476d21f0f04c5e8a23628a719fff8"
    sha256 cellar: :any,                 ventura:        "58c1575a6aa8ba019694ed1bd9564919a1b17e8b6efe87224c30321d6444e4e7"
    sha256 cellar: :any,                 monterey:       "a676cc9ba6e83f68b70daec6790bc3f054ec69a311636643c97dbf89bffe2060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5cdfab0d02fa9a06335b3804a97d61895fcd85d187d4b760de796225b40e52"
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
