class Crfsuite < Formula
  desc "Fast implementation of conditional random fields"
  homepage "https://www.chokkan.org/software/crfsuite/"
  url "https://github.com/chokkan/crfsuite/archive/refs/tags/0.12.tar.gz"
  sha256 "ab83084ed5d4532ec772d96c3e964104d689f2c295915e80299ea3c315335b00"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "65a13d4653a19e899bdbcec57f9d7dc4852dce18c753e31c42102f7ce734bda6"
    sha256 cellar: :any,                 arm64_sequoia:  "a927557fa509ed7f639826d4ba8c469eb580b53dcceeab6268a6519fc1b41813"
    sha256 cellar: :any,                 arm64_sonoma:   "80a144cb4f7425ae6d43e321080cbaad697626aba0356c787ab62a53514a5804"
    sha256 cellar: :any,                 arm64_ventura:  "7c00ca61a741c84e661cb89f208a79105453f051fb766390ca4afb6d5cbc815c"
    sha256 cellar: :any,                 arm64_monterey: "de3937f3b5caa7a27f48b183cca1a3dbe64fe0ba642f624f35a5d3e1827fa13f"
    sha256 cellar: :any,                 arm64_big_sur:  "8f4faf686ec2dd149e8c55505fb18f4f2fd246cf0966ed315c19eb811855aeb1"
    sha256 cellar: :any,                 sonoma:         "80c120367694a16a8aa47bea0107a4bbdf34cd765b1cb111e6ee59bc76815df3"
    sha256 cellar: :any,                 ventura:        "9044e7b8b91b781be38409cc180e7889fdf5430699025628726dc21919324704"
    sha256 cellar: :any,                 monterey:       "72d451e62bf3ab7b5b2d73d9cb4757946e1c0aa75c3c5f28c1c2d899d052bdd1"
    sha256 cellar: :any,                 big_sur:        "72b8c9d618a16bd4287990ae6c7b46bfdfd964cbe20582d4fa10f5b4b12f09ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "057472092e2730abbd995d9b23b61f77e9b6f5f829f36b63786110ef657c27f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a6dd13114c20e2a4bd3d82033e463316b635d8c7a61c582e299bca8832ec58"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "liblbfgs"

  uses_from_macos "python" => :test

  conflicts_with "freeling", because: "both install `crfsuite` binaries"

  # Fix autoconf failure.
  patch do
    url "https://github.com/chokkan/crfsuite/commit/a6a4a38ccc4738deb0e90fc9ff2c11868922aa11.patch?full_index=1"
    sha256 "8c572cb9d737e058b0a86c6eab96d1ffa8951016b50eee505491c2dae7c7c74d"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = std_configure_args
    args << "--disable-sse2" if Hardware::CPU.arm?
    system "./configure", *args

    system "make", "install"
    pkgshare.install "example"
  end

  test do
    resource "homebrew-conll2000-training-data" do
      url "https://www.cnts.ua.ac.be/conll2000/chunking/train.txt.gz"
      sha256 "bcbbe17c487d0939d48c2d694622303edb3637ca9c4944776628cd1815c5cb34"
    end

    resource("homebrew-conll2000-training-data").stage testpath

    # Use spawn instead of {shell,pipe}_output to directly read and write
    # from files. The data is too big to read into memory and then pass to
    # the command for this test to complete within the allotted timeout.
    command = ["python3", pkgshare/"example/chunking.py"]
    pid = spawn(*command, in: "train.txt", out: "train.crfsuite.txt")
    Process.wait(pid)

    system bin/"crfsuite", "learn", "--model", "CoNLL2000.model", "train.crfsuite.txt"
    assert_path_exists testpath/"CoNLL2000.model"
  end
end
