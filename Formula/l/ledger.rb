class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1cf012cdc8445cab0efc445064ef9b2d3f46ed0165dae803c40fe3d2b23fdaad"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aea0cf04c15d978a7cac17f8536febd31b720b6e01b0a890325a85b56f157738"
    sha256 cellar: :any, arm64_sequoia: "56ead85deaf625e42cbfe6653113235207b7ea948cf90a7562113c73d7553838"
    sha256 cellar: :any, arm64_sonoma:  "2a7e53b0ee3eeeba9b0e89a5200c3ce135fe1b004c181f4c40b2a5fa5da888ae"
    sha256 cellar: :any, sonoma:        "5b5cb3a934fcf0cd479766523380a0d5bea6ff7544fe7bbec4f1bda3f0d54a69"
    sha256 cellar: :any, arm64_linux:   "ef553d06835dcd445da99e14af1c8503739c30a0252fd259c5bc3ded341f2f0f"
    sha256 cellar: :any, x86_64_linux:  "3850091948830b9296f8095d86a47cb4dbe5633b25fa2b1cd03e944d30085a73"
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
    ENV.prepend_path "PATH", formula_opt_libexec("python@3.14")/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{formula_opt_prefix("boost")}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
      -DUSE_GPGME=1
      -DCMAKE_CXX_STANDARD=17
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
