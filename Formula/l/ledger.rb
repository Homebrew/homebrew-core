class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1cf012cdc8445cab0efc445064ef9b2d3f46ed0165dae803c40fe3d2b23fdaad"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afa0ba3d1ce8b6b36853e2f440429535dbdb0ca7c8a87802ebb4b43238291dc7"
    sha256 cellar: :any,                 arm64_sequoia: "23780fbf483e4ba89a0639b27407207ea8134ce8e06e17ebf2d7130beda7da4c"
    sha256 cellar: :any,                 arm64_sonoma:  "99bd6079ab40e3bc792762167c71ad8076fe61ca96ce8cfa0b1caf793ae68901"
    sha256 cellar: :any,                 sonoma:        "2fea951eeccff3bc8ecde0a05f8583bab5d33fbfabf88040476cad0fe940465f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128c7d8d7ad3481d4f56dba950236df2433e2d07582fa1f0a0ac8e79dcd88543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5520b6e7dec3bbb30c4962b507962dc0c0ea3fae89141d4e74497a169b0cf100"
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
