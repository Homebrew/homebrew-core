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
    sha256 cellar: :any,                 arm64_ventura:  "b4cadeddff0fd9aa68f065b11ffa3d43085a8f8d40bf86144e0f30eb09a5d9f6"
    sha256 cellar: :any,                 arm64_monterey: "64eb80922a7691edd063fd9f20e48c1b0fc187b35b207be16794433447211ba6"
    sha256 cellar: :any,                 arm64_big_sur:  "397ef66603c42f7c4f04ce6435a88389792e4bcd5d5115e596eba12493d9decf"
    sha256 cellar: :any,                 ventura:        "022e44b5c98b9a95018d8b56a67dc3bdb84dfc1e1dc9a71b50819b033c619c12"
    sha256 cellar: :any,                 monterey:       "55cf7f70458d6a7ae6f2105b0740fa21137891325baae575ae0de243c1c40772"
    sha256 cellar: :any,                 big_sur:        "6b112d60cfc260a0b06229ec0cb7efbbcf727d997355ac4b27f80b950704d80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f3f7aa8cbbe2be6fd355d09e6dcebe5df42fa67bf1b93b74bf516ff2ede80e"
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
