class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1cf012cdc8445cab0efc445064ef9b2d3f46ed0165dae803c40fe3d2b23fdaad"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ledger/ledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f0adc9be4b8bc90b8527fba0106347f5e81ef37ffadbf81f6746cc4d6205c055"
    sha256 cellar: :any, arm64_tahoe:       "cf894e129f3f47955025c8ecf25eec2c77b295ba90dfa4c0ce9ac7a7040c93c3"
    sha256 cellar: :any, arm64_sequoia:     "9437a3112a16f1b19696a7107aba68511b1b415d27f82e65bec7b15f62e56e31"
    sha256 cellar: :any, arm64_linux:       "9eb605f899f7f93aae4d54535668e2b041bc50e258a9e962c2b4c9a8c374e9d1"
    sha256 cellar: :any, x86_64_linux:      "efab455daed135b2f75a99989fc9c5b0c58b67f9cd5eb7a5c3a4f63daeb82d9b"
  end

  depends_on "cmake" => :build

  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "mpfr"
  depends_on "python@3.15"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  deny_network_access!

  def python = deps.map(&:name).find { |d| d.match?(/^python(@\d+(\.\d+)*)?$/) }

  def install
    ENV.prepend_path "PATH", formula_opt_libexec(python)/"bin"

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
