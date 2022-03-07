class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/v2.7.5.tar.gz"
    sha256 "7e77a91c9e2366b6be292188c1a36c96f8830f8a5f4a079fae7f73b9b0d2c8b6"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "223039df16db8fd0b74fa529d88109f1effcf55bec6e8db742219500b2e556a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25d33ae56faa45f19fb0c60c0c497aa076e5d77451b9cf6125dee9e537c6c488"
    sha256 cellar: :any_skip_relocation, monterey:       "2bdd09925b65740a5f2009f177e45652eb6cfdc52a92c8f8071cdad38c09d0da"
    sha256 cellar: :any_skip_relocation, big_sur:        "f10cce9b46dc8c6c73dabb0d7993952bf7e4eb5ae8a7b1849621f96e52b009a6"
    sha256 cellar: :any_skip_relocation, catalina:       "04c2148cecf6ea05c7bd108d66659bdbd830111076ee71e4e4a73ad0db78a615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd509e68d1f143445d86738c2cb7a366349989cb9cce0ae8b26b91e71b0b9d0"
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
    # https://github.com/JustusAdam/mustache/issues/41
    cabal_install_constraints = ["--constraint=mustache^>=2.3.1"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, *cabal_install_constraints

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
