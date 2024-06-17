class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v2.15.7.tar.gz"
  sha256 "a508663e2bd92c1b6326ce313c623c2fc2d91d9dec962e88d953b2dc49a78b20"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5481881fa877dcbe46bd9f97f7f3fcf2274a84e173e8ae02ec30fea007176d32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a1bfc86f6aec30f96ec68f27992a534718df9c0e415cd8333a63207d17a18c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc713df0bc59ece08548cc7467c230893f749545589767fc0e8e8099cc6833d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9d38311fbaee45072808985b9b5ae49ec44e8f3a0772d0afdae0dfb1bde301a"
    sha256 cellar: :any_skip_relocation, ventura:        "ffc975770e0e8a24eb00376e0b269a60039fb578e97dbcaed52ce2524f35d2c4"
    sha256 cellar: :any_skip_relocation, monterey:       "71cd94b975f7e4c9c42fb32a6ad2205776d8e62231f735f1248b1ef99a8f291d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afcfdf08099427176424cb420050adff56838dca5bf71f92df2394774470dd6d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink
    (buildpath/"cabal.project").write <<~EOS
      packages: .
      constraints: tar < 0.6
    EOS

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          All GHC versions before 9.2.1 requires LLVM Code Generator as a backend
          on ARM. If you are using one of those GHC versions with `haskell-stack`,
          then you may need to install a supported LLVM version and add its bin
          directory to the PATH.
        EOS
      end
    end
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", (testpath/"test/README.md").read
  end
end
