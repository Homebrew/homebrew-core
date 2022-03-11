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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8544fc3515d4f792e985bcfc87f65f9b6d172a393ab46dfb68f9698067f0c387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b1f9af2e37102a5986ba24591dad17800c4d8339b18dc74b11690b1a8a1fee9"
    sha256 cellar: :any_skip_relocation, monterey:       "9694d69422504e9531370a44bccd72a2a02f2e3811876ab4da7eb414a43567df"
    sha256 cellar: :any_skip_relocation, big_sur:        "258a48a663a48aaf3c7a7ae829e8ad3639efcbc9750158913987dacb89bf65dc"
    sha256 cellar: :any_skip_relocation, catalina:       "0554a6de930c455adf30e59e47d7a08603a282ed093dc314dfe059d6aed38160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fd574d73cb6fbd45707dfa91cf44a701e9db08d0f2dca87e6100307989c61f"
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
