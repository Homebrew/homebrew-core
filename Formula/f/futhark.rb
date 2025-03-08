class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.28.tar.gz"
  sha256 "fb2cdde6d1534155c79d1a614ee7e6ce001270b2fd4226bf27cb217a602d198a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba2f7fcae38dc58bd8e561ff1201afd5f26ce89fd77b11aefb057f1d6826129f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d46b12b94b335417e23dfe84dfdcd1f71b949086d4d4b76d3baa66c2f904d61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e7ec66ad76aa5e7a47b9acdc22ea351a210d5d8242e880d4011393e2e629661"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa8bd3125b10f81de6bd47cb96d5763f8aadda521f40057607b5f5d3f00652f"
    sha256 cellar: :any_skip_relocation, ventura:       "51b8124e07cd84f9da6d823e29142a93ce2e8c515d089553e33fbe72daa43bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2433afcc46ed7d82673d89ad36d99a64d947ee7e56bd95aabaa3f00b5be0594"
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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
