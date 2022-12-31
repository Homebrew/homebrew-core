class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  license "BSD-3-Clause"
  revision 11
  head "https://github.com/ledger/ledger.git", branch: "master"

  stable do
    url "https://github.com/ledger/ledger/archive/v3.2.1.tar.gz"
    sha256 "92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a"

    # Add compatibility for Python 3.10 and later. Remove in the next release
    patch do
      url "https://github.com/ledger/ledger/commit/c66ca93b2e9d8db82d196f144ba60482fb92d716.patch?full_index=1"
      sha256 "eaa8ec87f6abe2dc6a5c8530cc49856872037f1463ab2e98f037e2b263841478"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ca32c1dd2b126b3bccc39df580521ddc44dca54d2bb705b25f72a832565d204f"
    sha256 cellar: :any,                 arm64_monterey: "bd27554bb2573470cd09a1de662eadc37c6f8c93aab40a61eb6d810f017c8105"
    sha256 cellar: :any,                 arm64_big_sur:  "b7a4b5aeac4418d4a44799b7401f55e6ee4c70a107798f4ba7b434cf18166c5f"
    sha256 cellar: :any,                 ventura:        "099b8829436ba8b9a5a829ef1dc278549263aed187855ad1fda159121014485c"
    sha256 cellar: :any,                 monterey:       "2784429160f1a542e957672dd32c45a77b62a2f80a16884c63a36ccf01cde44f"
    sha256 cellar: :any,                 big_sur:        "e152d44b03f66daad7445c15b8475d87ec1f8b8440622932881e92ee2f9be919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59400e2c576b65415fa26f044d5152142449611294c3ba6d914f837f471607c8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.11"

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
