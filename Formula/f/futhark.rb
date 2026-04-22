class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.37.tar.gz"
  sha256 "2b793dcfa6273d0a42449ad3777ebcd54abfe2b756afcc322d95849b8d6b57c9"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e25f708464a1e6b0a0e7e6eb74ad785d7830b9ae6c9976b38da1b6d920a8df2"
    sha256 cellar: :any,                 arm64_sequoia: "0217c57b93676babdf85e02057c75e844df4080c51c5d29e931a7482239c7f16"
    sha256 cellar: :any,                 arm64_sonoma:  "283beff38c7ce55d7ca1b2487827c688a8e82b08f026800cca1ac4e028373914"
    sha256 cellar: :any,                 sonoma:        "79ed078d51abfcd9a75999e6700ae50660d2537e3f859e9be49bb18e1dc89b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076625a07bf44e52ed2912fb844ac0cccf1c1f71bf340083a15db9cb93437ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3cb68108a94bca17ef144d95c028882f6da1dab8b97f41055eb121de0d56286"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
