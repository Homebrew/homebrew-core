class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.9.1.tar.gz"
  sha256 "512d0188c195073d7c452f4b54ca005005ce7b865052a4856dc9975140051d9c"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14660a1d83c39b2739bfeb813d59f531a1bad657662d11c0b3cd7c3ad63a5b74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3dae3216629fe49908992c551348378ffc86643cd1c05eb5bb0c2c942eeccb6"
    sha256 cellar: :any_skip_relocation, ventura:        "b573c6e8ab2598eb71f5380428924d967ef2b90fe681d969a520f0df3e6c5dfc"
    sha256 cellar: :any_skip_relocation, monterey:       "9670b5f56fba10637b47a5218e07a89838bf6b60c4cbd3cd6bd6e72898921a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "3782938b77db10588becf4b2c5b3fec6b855e44b0aba0cb8d7552df462b438f5"
    sha256 cellar: :any_skip_relocation, catalina:       "8f179178636d27c08a6458c3398cc3701ce3c5689d7fa74a4ad0c65b5d6d0508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf7a4f5b5c4d00f33d139facf5de3ca2c4ab83dcd28cdc2c9344e3ebbae66de"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  # All ghc versions before 9.2.1 requires LLVM Code Generator as a backend on
  # ARM. GHC 8.10.7 user manual recommend use LLVM 9 through 12 and we met some
  # unknown issue with LLVM 13 before so conservatively use LLVM 12 here.
  #
  # References:
  #   https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  #   https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  on_arm do
    depends_on "llvm@12"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
