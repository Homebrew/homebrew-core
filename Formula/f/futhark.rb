class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.11.tar.gz"
  sha256 "89778c728202ec8f13146509b902f8362af3ed1433d510e2956217dbd0c682bf"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a91face15095ad16a1638a653a5b1007b19b5f78d7fe07bb14880d38d9a505b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcfeeea5f45d3903bd66df5334e0d758f665332bd3aebbbcdedf2c24d55be999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737a569734ad3df9540202b86ad30ae3cd2cf3274dfb3596520a0d486479970a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c44cc55efec75e48e020d9142243b154eb2935ab29ba6794045af844824110df"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4da7023c08850b17564ed88f6db20cfdf0941c2b0299367f7f069f714442d4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e865b7092d4fd7ae51edea9fbc463e50bb8a4851d1dad0394ad8f331ed55ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1cd433bac11193fc9d260489e48321890d72ffc7fdc4fbc4846665bb846cb4d"
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
