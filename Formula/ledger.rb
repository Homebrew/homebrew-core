class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "649dc9b2c1c2731080718bd70fbd868dc27c40c805b98180efe7b29b75411d90"
    sha256 cellar: :any,                 arm64_monterey: "83145c30791376d865638bb4d773389e455d76c5a15ec149b325053188d0c1a3"
    sha256 cellar: :any,                 arm64_big_sur:  "67b305d4dae1ac2c15dbd4e9eea464afcd39eb9b7dead40f006555c9cd50a2eb"
    sha256 cellar: :any,                 ventura:        "e651f550d6a31c22a43efd53019de2ff3c9f7b232040e9361894fc720d7738bd"
    sha256 cellar: :any,                 monterey:       "35f6f93b07dd0a7dc4293f501ceab1a0c2391a9067f9a1e298466daf2c755c2c"
    sha256 cellar: :any,                 big_sur:        "497dcb6ac6315a37b60b08935953cff4a1fa5675ad5f4c002f1ec98097438f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ead2468163999abde0e5a22e57d98f20ac3cd7d4cfb5230b4572cb0e8dc3026"
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
