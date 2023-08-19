class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c83ac2d2e77e26d1318b7b4d74864c795bdf8a5e209605a5a0be1b5cd94baa2c"
    sha256 cellar: :any,                 arm64_monterey: "44a9a8feae3f659231f2c73a4df8be7c3de0f248774e7e48234b773df314bb17"
    sha256 cellar: :any,                 arm64_big_sur:  "5004524e2b4133730fecacc855d4bf61a5ac79e155c6616d22513e9898787330"
    sha256 cellar: :any,                 ventura:        "82b7edb137dfc24db8b617dd7ff3e3045e55732c50168ace7a0615d1b36f04a2"
    sha256 cellar: :any,                 monterey:       "084ad5855d53c11e4f153cf1462810f9a2d2b8d74147f7baeabb0e725b775f2c"
    sha256 cellar: :any,                 big_sur:        "adccf26b056139a2745fe94d8042ff7c5a288e884b052084d01306d674f7c16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4235498b2818e872edc72e20181dd033bc08d7f6a2e99919673f597eb3b45a7f"
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
