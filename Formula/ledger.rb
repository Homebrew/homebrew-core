class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.3.0.tar.gz"
  sha256 "42307121666b5195a122857ec572e554b77ecf6b12c53e716756c9dae20dc7c1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6b0e80aa111fe117044138e21251ef5ffd7d33d19747826c46fc7acb462cbde"
    sha256 cellar: :any,                 arm64_monterey: "3d3b2e6b3371c19440d9a286697fbff1207e48eaf43e92f37b91c485dcb69c1e"
    sha256 cellar: :any,                 arm64_big_sur:  "3f9948241712f76991a62c63d0c63d111c37df1af29c2f3ccedd100b52fb0760"
    sha256 cellar: :any,                 ventura:        "4221e410637fa6eef3519cc6e22c858e361c8b9a3ebd8f5869054befebf1839c"
    sha256 cellar: :any,                 monterey:       "9ea0ca4261eb3692db999fa39f5f3961cb263cb3b52ff6e8cfb904bec314ed09"
    sha256 cellar: :any,                 big_sur:        "14271a46b2ebe02d97e2ca83c22cc7a6a9aa30c351a7165025c61324061d4427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c9d9dacd8bef370fb955d82631dd102b04a29a148dfb153e865796834bf5d9"
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
