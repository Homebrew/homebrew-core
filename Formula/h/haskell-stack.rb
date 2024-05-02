class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v2.15.5.tar.gz"
  sha256 "39c192f7dd6e1c41da55c2128c5c5b39a18e6fe57ac69cef7396f1e65f7de8e4"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "236cffcba74603b1d06aec86d1a51e894ee4c5d00bc70e094e70b019224dbb80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd37843feb7d01c6ae7d253cc0e554ff12faa0e8fa7406ea44081e7c8d782e25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ce315ed896195af53f10d436ab74fb97b440dcc92f730ee6f2ad385a8829b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e9214af75de6d0d85daa17b8f78c7be7542497da315e741890c3217c2484177"
    sha256 cellar: :any_skip_relocation, ventura:        "737653e3fb423bfcf8bc1fa97b8628c4ac50b9438b03733f83d1c49ea419dced"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a6e360974f29952ca075422eda6bfe6b164ae0f601ecea48940c3024aac1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "974537686d3191778f0cea7cada915d29f792f6641b8789fd89b7b4137634f52"
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
