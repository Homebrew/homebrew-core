class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.27.tar.gz"
  sha256 "7130f6591b157f620489332ab78f5820da32017e854171a91d2e50f8ec888033"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676aa2b283bb9396ce3f3cc0a4e91f749f7919e58ed32db73352c80f8b5faf7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433905e380e59cc610c1955ee3d33d37fec827f9e2c07c2fe7d7f6dcf7688d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9e5fafa17fcffe246f77bc5246a35a372da2fedce53ca0d847cef889f6abc7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dbb2e422ef6c9e4e99ca934c08f165a6d8dcec97894aae4baa19887eb65bcdc"
    sha256 cellar: :any_skip_relocation, ventura:       "910ffe5f8046634f71ec07f79623cf0c6095007fcbb9bae08a1c160d0fa0b87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34934c70863472fb9f9da246af56397ecbc3793296a764a87b8958071355d1ee"
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
