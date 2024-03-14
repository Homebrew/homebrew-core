class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.14.tar.gz"
  sha256 "859a31828dc897b06d39a576c16fb7263cad3a664535bf81460dbc70efa88450"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f0cf6d9209899993fb51ce5dcd1f987e42117c4b9de345bad1b1e07b9d751a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ef087c5d43c8b5788ed9a4355d8f4bda1a226af27c18c26d82632dbbbdef7fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21b54dc27e6bd564ef8c8e19e084c2339e6800289500817c2347e537c27e91a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c25059a3fe33170fa5139659ee9493515bdc9522dc66bbdea06596ce84d244b5"
    sha256 cellar: :any_skip_relocation, ventura:        "0c27e2b75134304f71056d6e3593044f670b6ee18954af6d03dcd607000fb940"
    sha256 cellar: :any_skip_relocation, monterey:       "477acad0100406e5a7cedb6fc9780581f513373bc74bbbd34d212f5299923cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8eaaaa696d2d9af81326a3e256a9037d38d000444bdedaf577f4fdd1fb3978"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
