class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "74ad174c55c98f56f5a5ef458f019da5903b19b4fa4857a7b2d4565d8bd0fbac"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6970c6203f7482aa1bd5059524f8620ca3a5576794fd9a81e81f77388e6e83ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97120147f0fb716e7c7c8ea99d002c8ee7e5291dc85759b53cfabcf4a7fea9aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309d3c7521a5df32b3d6f5e11f63c503498562702f6dbe49e602bd00cbfc2733"
    sha256 cellar: :any_skip_relocation, sonoma:         "23904061a39a7fdb886d8557b2a67a2975639fe110a0debf266d94ccb72da877"
    sha256 cellar: :any_skip_relocation, ventura:        "dcf124afaed9cb7c51ddcdf4c188c819bf7000084e39ce3c3cf51ea687933f01"
    sha256 cellar: :any_skip_relocation, monterey:       "87d9810d0b59f7d8640aad06b4ebf1e052fadbd2f10345404bf7a5700bb7151a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e8608671f3f2b024804503619e50e7402157e1da6f4e689c8137f1776ee498"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "zlib"

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink
    (buildpath/"cabal.project").write <<~EOS
      packages: .
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
