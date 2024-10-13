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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe17a5457cd6aa4667986e50da4c10a2d62e8fada679a826cd9aa6681661a82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6576d6d8ac9f556b439115476020b4bca320dff2d3dea510a05296073d0192"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0306a15e9eac83d5824fe35bd4ac3d56a198f0d3a4afe0149429f1e7a1863fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd846a3e9489aea4e074b2c4880a8a442b46a2a9ce1025f0d4985cdb1addf68"
    sha256 cellar: :any_skip_relocation, ventura:       "9c56477a47316be12a676dc6c9b3b733ffa6cba2dd6335fdc8b8f5af10ae31c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc5821f3c34d5b38fc82a5d7a2aaef2d62082848134dd335d6fc7968736563d"
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

    generate_completions_from_executable(bin/"stack", "--bash-completion-script", bin/"stack",
                                         shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"stack", "--fish-completion-script", bin/"stack",
                                         shells: [:fish], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"stack", "--zsh-completion-script", bin/"stack",
                                         shells: [:zsh], shell_parameter_format: :none)
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
