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

    # Backport fixes to build with `boost` 1.86.0
    # Ref: https://github.com/ledger/ledger/pull/2381
    patch do
      url "https://github.com/ledger/ledger/commit/ad93c185644cfcb14fe4a673e74a0cb5c954a4b4.patch?full_index=1"
      sha256 "3d2db6b116cd7e8a1051ac7f92853f72c145ff0487f2f4e12e650ee7ec9e67b0"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/4f4cc1688a8e8a7c03f18603cc5a4159d9c89ca3.patch?full_index=1"
      sha256 "938d62974ee507b851239b6525c98c8cb1c81e24e8ae2939d4675d97a8ec8f67"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/5320c9f719a309ddacdbe77181cabeb351949013.patch?full_index=1"
      sha256 "9794113b28eabdcfc8b900eafc8dc2c0698409c0b3d856083ed5e38818289ba1"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e739f7a2ee6e2d44b607aaacf253df09f0d9fda48f32c78a6201e2e53a4dcbc2"
    sha256 cellar: :any,                 arm64_sonoma:  "f971e44953f6db8f4756fd4a6a440c3bf014eca8831ce1dc8defc04b366c73a3"
    sha256 cellar: :any,                 arm64_ventura: "c3ab50d8df4c398f04cc6595f292a9659e7904f09d6e6f165d47333c99c44d31"
    sha256 cellar: :any,                 sonoma:        "c999180f1c610065777bb800aea211dde3a6bbfc1c44a7f4cdebc251f4615174"
    sha256 cellar: :any,                 ventura:       "747dbb2eafdce945665f1f695158b45c3ca72a3e2e147020b6d16508bf814c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb701b5cd3c4d98e9d7f2c3940ef8862c6199309648660d8da9d97e1c0bdda2"
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
      "--file", pkgshare/"examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end
