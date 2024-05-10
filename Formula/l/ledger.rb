class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  license "BSD-3-Clause"
  revision 4
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
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb9834ceed45016edd34db30241a5474f8fe6cf55b75f9c8a63e1d8c6268ac2b"
    sha256 cellar: :any,                 arm64_ventura:  "ca8de31777a7dd2afc9735b178e415e5e8034e34585193f3c68b31b39f2fe64b"
    sha256 cellar: :any,                 arm64_monterey: "820af38e740ca052be182d4922ccc25cb5f9b15dd2ab83bea550dd8b275ffde8"
    sha256 cellar: :any,                 sonoma:         "3f41fb3d90e6b5844ac30fa76a0facdb185ffaa78d711e64f887e5e8b147943c"
    sha256 cellar: :any,                 ventura:        "2555b42ce1063b39910f906f7250080776884ebd1555e51a35dce1eabb88a48d"
    sha256 cellar: :any,                 monterey:       "c20b917ab8d18494aa0bdb2fb8d8e6bba5c4c2909ae0fc5eb3c8ccc4b2b4e699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d960afd65dcd0c32dd4699883907b7a444e1f32753a03082b07826f6e7b7f09"
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

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https://github.com/ledger/ledger/pull/2337
  patch do
    url "https://github.com/ledger/ledger/commit/1da89f6ffb44a44257b9774c4ceb71e7b495d677.patch?full_index=1"
    sha256 "8aaf8daf4748f359946c64488c96345f4a4bdf928f6ec7a1003610174428599f"
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
