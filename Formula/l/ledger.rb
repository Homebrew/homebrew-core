class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1cf012cdc8445cab0efc445064ef9b2d3f46ed0165dae803c40fe3d2b23fdaad"
  license "BSD-3-Clause"
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf820b2d7abb56f2c03dd6873ea9090e598d5dff4bf1cd1fd3247333175359eb"
    sha256 cellar: :any,                 arm64_sequoia: "0efd7758b4eeef3951903338bcca57419317a5640506f3ae91f99bc80dc77318"
    sha256 cellar: :any,                 arm64_sonoma:  "6231e75781b9f906afb6a5d48f58b210782ecfdba71cfa83e2c0a131d9c417d3"
    sha256 cellar: :any,                 sonoma:        "425c3e9b8e0fc413bff5a3dbecbaf0756bf52a7edaa5c871c40b24b9829a6696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdd70af7b87fea7cc5d518b10b63936152cceaf2902cc824cbf184d050939fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e526e9ea8e9d85f674e6e351c789fe856f4592b1b1b9f7c5e4e5909066ad321d"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "mpfr"
  depends_on "python@3.14"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

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
      -DCMAKE_CXX_STANDARD=14
    ] + std_cmake_args

    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash" => "ledger"
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
