class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "9a8dc9dd403fa8fd56339353091d438fd5d97ee6f2001a0cc11ba94b19271d98"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92f9a32629ec7e0985fbd3c36b78e702635c94e3d257e430c31e29134cb88f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fafbac5ff1031862e708ae74fd73868f0240b89cafd8531e5109615a60d2a226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a4821091488b3a6b1271d0b77bc91ec63960ecc4adb2e04a94ce6ada47e2bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e43c19ccfeddd96f94b53c11bf2997668349031da3b231e1e889907ed31377"
    sha256 cellar: :any_skip_relocation, ventura:       "0c5d5a72df064a4c0df6425aebaf9d2f57a310239e4dbca6f3ab45a0c0a41a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d181279a2913a0f3c6e407cbd860dd1072cd5bd04c24e89f75ced0b1b0a7c3"
  end

  depends_on "cabal-install" => :build
  # https://github.com/commercialhaskell/stack/issues/6625#issuecomment-2228087359
  # https://github.com/commercialhaskell/stack/blob/master/stack-ghc-9.10.1.yaml#L4-L5
  depends_on "ghc@9.8" => :build # GHC 9.10+ blocked by Cabal 3.12+ API changes

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

    [:bash, :fish, :zsh].each do |shell|
      generate_completions_from_executable(bin/"stack", "--#{shell}-completion-script", bin/"stack",
                                           shells: [shell], shell_parameter_format: :none)
    end
  end

  test do
    system bin/"stack", "new", "test"
    assert_path_exists testpath/"test"
    assert_match "# test", (testpath/"test/README.md").read
  end
end
