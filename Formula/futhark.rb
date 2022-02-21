class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.7.tar.gz"
  sha256 "98bb30704c41be2b8e6dfec09272c7f2b81dd87204e4bd97a7fe6e4ac617fb06"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9137827d9800c15ca9e8d7bd9c64304638c37669c7d82efde22bfa8577f4ece3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cba28ba99806d66104f32f8528654f8f5faa10c1d4e8ba355a7b5cd1127ee6dc"
    sha256 cellar: :any_skip_relocation, monterey:       "db2c05564030938dc7a11446072a5a1976c15db0ca675cf54523f463d8425e75"
    sha256 cellar: :any_skip_relocation, big_sur:        "6525a17af9caf7e5830c9c9d8c5ce7d2be49ba024c2ce9b06a7d3d92a5e2fe86"
    sha256 cellar: :any_skip_relocation, catalina:       "26476973c20b97d13a89de274c3f2d161ad015984b8ef5fbf69f880bae2c642f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d3c9220c9d215e44ab108ec449be12b7cd0230c3631a573640e589dd5fb5ea"
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
