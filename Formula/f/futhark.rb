class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "372c2e10f329430ccc7154293418457b12655e27e4726154b558774056e61ee6"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1189f5ef16af6dbce8ea11746285bada1cadf48eab8d2c1cbf48d832093048d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9d2f18e35b302d4585a50aadd7135a67e11f7d898443739ee36bf580ee184e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef9f78ef7a9130caa4aa6191fd2d5b788aaaf0a449a9f5b20fa2ed108933a157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a8f4992b69e765f64d1438b6d6269a19be60b4576e1f1da4c147cde6ee7e9a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "758e180b9943a5892e2b915e2c5f0e9605c5185fcbb9a9ea758644446afde4ed"
    sha256 cellar: :any_skip_relocation, ventura:        "47fe79b39e570e38361102a1d90c9f73890b9d5e067613294fa10a7623ea1f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "b608f3ea8a146ed2f839d119dd2bc82dcb974a5b3f50a99363958008c494cdca"
    sha256 cellar: :any_skip_relocation, big_sur:        "419b2e8fdec7b02df289c8842ba1d76a7fa0d65d1afcadc8e8e2ae302de673ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6bce68471e23dc16093f5e7297de0eeb8f416b734c5dcad409bdb97489edea"
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
