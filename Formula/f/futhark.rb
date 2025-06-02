class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.31.tar.gz"
  sha256 "676a0e720f1e102353a99cca111b3502fd0c594d82e81063b84ad9f8b52de718"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ccfd1e707cb8620757768ebec43f468189054e5ce67a262ec422e9923e58658"
    sha256 cellar: :any,                 arm64_sonoma:  "4073ca8eb145c04f4e3a542710580e31c30bfca53a53fba41be336906a91cb37"
    sha256 cellar: :any,                 arm64_ventura: "07316dbde0b53430ead0cbf0be40270f1cf3a346258f8b2ecf85dce4d6894367"
    sha256 cellar: :any,                 sonoma:        "fa0acdf21bd637f2067fff8fb338c9e92a08bf0f7a7a0ccc22402b787fc38a2b"
    sha256 cellar: :any,                 ventura:       "1d921859887712a305cc8377cd14b5db05c8b7e1a03b0e0048f68dfbaf0fd434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5e06d73fbddba92c8035439a35233c24fdb93bbbac344b76e4f7ce6a1cb65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d7f02f4138116b450a6242829ff894014586447ff5a78db27a22fd2a83fe52"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
