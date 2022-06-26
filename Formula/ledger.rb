class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.2.1.tar.gz"
  sha256 "92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a"
  license "BSD-3-Clause"
  revision 8
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37ed1f1252a0d6fc2d03e992366b42f796ee1d20824ef33f2edec255cca37ead"
    sha256 cellar: :any,                 arm64_big_sur:  "527153ddc9398531a048d9f44515c4957056a2c2516a4549276a49725f619aa3"
    sha256 cellar: :any,                 monterey:       "e7c98a74ce6f898a81ebb3ed16a4ed632d642d01bc9fc3dc9a92db89a46298d9"
    sha256 cellar: :any,                 big_sur:        "4268a869cff79e90071ec4dd922dfcdb794d60915bc9d537a7678cff3474a57f"
    sha256 cellar: :any,                 catalina:       "4d57f51ac997fc69b854c52419cbe41d81c009ecc64963a8c11114b5b75170d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ba0f4b37b449e710d9377f2d38fd92599ed3af9bd6d1bc0be042ba8cbacd5f"
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
