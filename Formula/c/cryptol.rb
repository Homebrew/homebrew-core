class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.5.0/cryptol-3.5.0.tar.gz"
  sha256 "7341c026ef83b18d2c784cfedb37003f74d1560605cd9c3107b5b6fc31fb2f84"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f5f24a0cd70a9680033bcca7983f92298b9970819ea5048034b01c06ef761755"
    sha256 cellar: :any,                 arm64_sequoia: "05b0c231a927a089c6eb30e5fdf2be6800acb034165831a7f922d95b5b03395e"
    sha256 cellar: :any,                 arm64_sonoma:  "e56cd834fbb39dedcfa204a32722f2cfe885dd4f648857479c20e76892a25ef1"
    sha256 cellar: :any,                 sonoma:        "a3084a03efbd1b3d8a3ecfdfeeebda0f06e235652a0204ad4e7b663568c6b659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4a6f9b4ce272625e31eb25a4f2f3a955d2a219dedc3b9cc4ebd95625bedcf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0691ab5284a9b219e134f6f93a10ca1023a964590c78b03621f15d1fb199ed6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "z3"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
