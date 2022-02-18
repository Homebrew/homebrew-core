class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/v2.7.3.tar.gz"
    sha256 "37f4bc0177534782609ec3a67ec413548d3f2cabff7c4c0bc8a92a36e49c6877"

    # Due to recent update of aeson-2.0.0.0, stack can no longer be built with
    # cabal-install. So I patched stack to freeze cabal dependencies using
    # stackage 17.15 LTS.
    #
    # Reference:
    #   https://github.com/commercialhaskell/stack/pull/5677
    patch do
      url "https://github.com/commercialhaskell/stack/commit/05951f21.patch?full_index=1"
      sha256 "bc12787bffb450ac7246a34987e2d546325e6ecb0b5c75f6bfccf1b32f9693aa"
    end

    # HEAD version of stack has already been patched to support Apple Silicon.
    # However, the next release containing that patch hasn't release yet. So I
    # manually patched stack v2.7.3 to support Apple Silicon.
    #
    # Reference:
    #   https://github.com/commercialhaskell/stack/pull/5562
    patch do
      url "https://github.com/commercialhaskell/stack/commit/32b80476.patch?full_index=1"
      sha256 "36e09f68c951adb0b35a0d9a510c9c367554058d690c667636147f1cb483ef8d"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f787639247b432194d1adb01b7c012de6e30b141095644c95b516c25af7c69c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1febdf95d90161093914f0b130a2e560e3e536316b414ab4d894195f2ffbec61"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b504eb4506d7cc0aa84e917018897ff0b00f9f863b8abd6c0f05ecbd5fa9c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e9185c5fb43ee4aa892bd5e9460fba19874c741df8cb0791af25ec7dab40575"
    sha256 cellar: :any_skip_relocation, catalina:       "eff4da14356490588c31bbdf4d327605c5209957956d2964eb42e65bb9f687ba"
    sha256 cellar: :any_skip_relocation, mojave:         "f57fdcf4118acc46b507b6e091f8898f9f1200f5041d20460ac97cc57fe21364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0e6d39df1e8c28c0ed815df4a2f02a3e302a758fb9dade1aaf3d13212ce5ad"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  # All ghc versions before 9.2.1 requires LLVM Code Generator as a backend on
  # ARM. GHC 8.10.7 user manual recommend use LLVM 9 through 12 and we met some
  # unknown issue with LLVM 13 before so conservatively use LLVM 12 here.
  #
  # References:
  #   https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  #   https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  depends_on "llvm@12" if Hardware::CPU.arm?

  uses_from_macos "zlib"

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
