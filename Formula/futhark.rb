class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.5.tar.gz"
  sha256 "4a7d5f5d0de94e33c622e8383e66272ce26ad1e5719bef72111e615f990182f9"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1d9696ea1bea68156ad54ba4cc95752d4310e2d343da2eb6fd002e56b61b94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6dcda6e90479f9e233d9872ced2b8785f7fee36cf153e896bbda0fcbd8cd15"
    sha256 cellar: :any_skip_relocation, monterey:       "002b435e5456323e4c3841b3e148e85dfbf0fed53868225edb359ec10aa2c3a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "64df312443527f5fb45b436efdb8424fcee6005c865739f83199549c9f6392e8"
    sha256 cellar: :any_skip_relocation, catalina:       "8dcdbf2e64380e15e5dfc82272ed9b039da0de39dbbcb13959f3380d41c744ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcda13fab2d7194bc8896bf4339bc0de299f4d4c95ad87364ca7959a8231fdd8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
