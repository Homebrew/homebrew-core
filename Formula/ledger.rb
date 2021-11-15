class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.2.1.tar.gz"
  sha256 "92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a"
  license "BSD-3-Clause"
  revision 7
  head "https://github.com/ledger/ledger.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d9c6979d1708333ec05d9106ff3b10e9d81e565edc32e3299bab5e8cc9b1d05"
    sha256 cellar: :any,                 arm64_big_sur:  "f80c6502c9966f8c6c0fdaa04257abe0ec381ac1e71d5c8c7fa040b5f17bf7eb"
    sha256 cellar: :any,                 monterey:       "dca01afc7d8f81afea1458eca84e69b775a3e43387b7ff296df8857c6d7abded"
    sha256 cellar: :any,                 big_sur:        "43b45dca311aaac9d9beaa116d7460a9c8ae1018e196e627811f34b0a33b4e33"
    sha256 cellar: :any,                 catalina:       "339bea75fa51d131603613fb31e95c0b0774cc00e30a7accbcf0560bf8d8f900"
    sha256 cellar: :any,                 mojave:         "7a030e18924a202197ca72c04fd9f147930e021b428581c7e111dd00acb0dd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e62b1de7a6c8f43ba22517035871c6c47010d52f007e63292f89116b5d8cdc6"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.10"

  uses_from_macos "groff"

  # Compatibility with Boost 1.76
  # https://github.com/ledger/ledger/issues/2030
  # https://github.com/ledger/ledger/pull/2036
  patch do
    url "https://github.com/ledger/ledger/commit/e60717ccd78077fe4635315cb2657d1a7f539fca.patch?full_index=1"
    sha256 "edba1dd7bde707f510450db3197922a77102d5361ed7a5283eb546fbf2221495"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

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
