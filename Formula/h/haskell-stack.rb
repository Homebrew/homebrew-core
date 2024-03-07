class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "f81ddbcab12c7647536128ecda2acb6fcd91d18474dea908c53848314bd7c867"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0426cc31adddad813c139f9fefddce55a6e614893f2c1052b3ae56c0a9958cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3269aa3a8dcf82d1c8cbb8e362ed4609d99193611ece6ef0c00b1c820c9494f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f20bef09d83372ced23f7cf80a7174a70640da5f228729b1c8b4cff39ea6fa2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ec70b9dbe8c49239f6058f8ad647478a063e879ddf663c49be1d9623e11fd1f"
    sha256 cellar: :any_skip_relocation, ventura:        "ece414965294e7d82b7c073cf3607822541cec6ae171360fbcd01cc18da91ef8"
    sha256 cellar: :any_skip_relocation, monterey:       "70b7031bd72c6c17ae139094c4471728a9d13d4e9b6141c7ac7818d39fd7fbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcddb8cc82773695f1733fb34caef081a8cb6f9a953e847ae4b7d5c1984c590"
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
