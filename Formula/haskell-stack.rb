class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.9.3.tar.gz"
  sha256 "52eff38bfc687b1a0ded7001e9cd83a03b9152a4d54347df7cf0b3dd92196248"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d893b6d53dc84e774a0d37f946641365a70f1664bb7184416629e4604b76ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "715dbb96da1591cdb255e742957e48e8c18649603eb6562c0f3ce71c249f823f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af09b4f95d5a7d48276cc6e02fa5e5090c1aade542e6a28bca8dd7245d19b79c"
    sha256 cellar: :any_skip_relocation, ventura:        "7dd9e61b7d2851a9efbc31214343dfd7fb075f20677bc42ce0ed377bd210ac1e"
    sha256 cellar: :any_skip_relocation, monterey:       "f114ac554db5c1b8c5a9fb1a28b618f61c75541229710b99517306bc95634112"
    sha256 cellar: :any_skip_relocation, big_sur:        "18be789e3f5f903cc5832d6a6bf9ba760181a745fb0638bddd05a4d3c0bc7678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6204f5ceb568e94ce35a4f77045b368fb72d0745c806012b77308fbf8003e4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build

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
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", (testpath/"test/README.md").read
  end
end
