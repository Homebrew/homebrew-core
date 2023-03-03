class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.44.0.tar.gz"
  sha256 "5b9707f0d16e3b063d824c609a692e7fe60725bb33320dc0d0ea06197bdb9a18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7965a86dff95a89f0dc6ad276af47f8e68915df3eb01d0a148f9c3bf01062e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152fd92d3ea06b8d4f9b1c66216734aed7fe3cab1d98a28fa0a54b545c6b96fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075ab34319f4531b7223ea2e964d9ffbefb4b8deba7fdcc338bbef2f6d7a9394"
    sha256 cellar: :any_skip_relocation, ventura:        "80c9d7efa977cd55aa7042af48bc6b49082cdd9658334cd1b541b4ce6cfc7fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "3c18f642e1f9e50f7f39f9da92000153f368efc1088443ff2a2feb05ac8b26c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "25dccb452732379d2a39b648cea5432ed9a42ced3af5609bd7c5a2a8fc7ffd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f86864bd360d39e7c035be6e40756a7012d92ab9fca35944a5c14a6ac3ef05"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
