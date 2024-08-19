class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/ledger/ledger.git", branch: "master"

  stable do
    url "https://github.com/ledger/ledger/archive/refs/tags/v3.3.2.tar.gz"
    sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"

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

    # Backport fix to build with `boost` 1.85.0
    patch do
      url "https://github.com/ledger/ledger/commit/46207852174feb5c76c7ab894bc13b4f388bf501.patch?full_index=1"
      sha256 "8aaf8daf4748f359946c64488c96345f4a4bdf928f6ec7a1003610174428599f"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7fa6f760b136e2104925d5e0126baa56994691e111a486be71b88048acfa2ad"
    sha256 cellar: :any,                 arm64_ventura:  "9706d5b3817874dc3c3fc3696ff5c7ce1418e20b15dafaaa21d612e80b3688b3"
    sha256 cellar: :any,                 arm64_monterey: "37d03c5f94bcc3bf843ffd5c6206a2869093f0f7010c2dc91b52a6553c1d5b70"
    sha256 cellar: :any,                 sonoma:         "d55ed9442b00f1db45976256fdabc1876a3b9d7d00e58ddb1533702a32682619"
    sha256 cellar: :any,                 ventura:        "5d95809213044fc8056ca3b642c21d22b3ca2ebce5750fd6a7477e2d96dc55af"
    sha256 cellar: :any,                 monterey:       "f51d0330df39298a2a313b7c25b3bfa0b6a110471b954d630d02910108d237a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a5e1d2c1d8a3c8841191e3a2d6f1a0932cdfe7bdfd9df55e1681af1f349704"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost@1.85"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.12"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost@1.85"].opt_prefix}
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
      "--file", pkgshare/"examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end
