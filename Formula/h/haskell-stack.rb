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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a18717db5c10d7146575564f63dccc58018379a2dea2942d60c056a33f1bc883"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b49811d11f21942a71194d3cd2bdd844248a3e41dfec1104f4c3910e4afa639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c03ce3857fea784b191bc7186f13509915f20ff676fd1e4a9c4bdf1a03c9250"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e03d9272d042d571c6303d1905b5c91a5ed590895ad0ea1e933a0dabae2fad8"
    sha256 cellar: :any_skip_relocation, ventura:        "a2857209d6741b5c7db927724ba1772f26f8772100ebec974873e6845f3e3a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "516839b97c7b5f47c1460c1a10df62002554c76f4e8fbd8dfbe41a19098621dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1cce6bfb7ab4dfa501c68a592be895db8ee3ed500296b1cee5708396b1d1fa"
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
