class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.14.tar.gz"
  sha256 "9b0e10e87feddac3e1ac4d9c1ee285c2be18e8bf57a841a968d11b938b17d6da"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b86af361a6661dd55df6c36ad0deae4e3a3135527900ba0999163e03d26a8884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a2eb53841a3e9ec66816a4bba4ecaf5b568e857378ceb4932624915cb1bf59"
    sha256 cellar: :any_skip_relocation, monterey:       "0610d16a55bfb897df0699fcfee3deeede4cfde07ab907d017e36284b5e2815b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c052220584ca9a0e35eee45c8acc69b9fd9a3a135a8bba8359f14e4620b09de"
    sha256 cellar: :any_skip_relocation, catalina:       "f8004b0aaa556a2bbd7314d492de7f5a565e102391247c84e661f6873365bcd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e075d4c1bdd1c9835c9debd221d5b51e9bd55b22f60fd5b6ccbc016182a0bf3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9" => :build
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
