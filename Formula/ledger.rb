class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.2.1.tar.gz"
  sha256 "92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a"
  license "BSD-3-Clause"
  revision 10
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62a789e94eaaae38c4411a313dd7bb782790a8c39f6a52e662d5b7b97df4e6f1"
    sha256 cellar: :any,                 arm64_monterey: "6ee63ad79bacfc3c3dca62bfd2afddbcbefc1621265adeb6f4ac33d5b7987ccf"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf8abe81a38cb217b280187e679ebaa6c61960ac84de3a79a3be00f623d98b9"
    sha256 cellar: :any,                 ventura:        "8c6c9063ea08e1b405a70cbaa4d12cd2068dbf7233e0a3f9ff75dc4b149802e5"
    sha256 cellar: :any,                 monterey:       "4cd298ab7b1df2014a045c1fe0eff8d0787fb5bfde0b9e29015cff3183e60c66"
    sha256 cellar: :any,                 big_sur:        "f3df57ec7e9bb1c266406a25a7ccd9c477ffaf52ece04eab735cbd68060f2653"
    sha256 cellar: :any,                 catalina:       "be65d6f0c4324d44de6be95e903c82f98d90a624b84975ec1a139fd8c67e0d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3c33796a13d85404cb97a53e4262b7fe7e78b9bf11ac66f31c1d5fb4745700"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.10"

  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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
