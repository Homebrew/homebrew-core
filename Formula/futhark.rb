class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.8.tar.gz"
  sha256 "830579b3e45b97a2e9e1ca423a271d311fb84ebf1b2a9f1ed4063d2408ac2dca"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d09fe3aca79428fb4e33ac4961897ad6f833dfeff03588d0ddc8a37583b968c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c13ef6614240c930e147277b1c674761962dc069e8059213d6cd614533e7d381"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b77d3113dcf8cfadb7c7976a68907288d7c6e2280ed821e43057604a3bb3b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bd2202346f1ff83cceb27d7e3ee63ca5b99f5894cc70430760a639b413c146c"
    sha256 cellar: :any_skip_relocation, catalina:       "719d259dc3e4210ec39a48d0410d50dc73bc0218ea83594b28c3676bb53ad404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718313d39eb283400ed1756b4cb715ad64919cb9e9d701a41862b615a97449f7"
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
