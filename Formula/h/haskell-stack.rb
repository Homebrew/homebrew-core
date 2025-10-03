class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.7.1.tar.gz"
    sha256 "e2ce0d053566634a426ba1916592dfcefe48bdebbfe6a0da07e23a79c0ed7759"

    depends_on "ghc@9.8" => :build
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af23e3d97a6a29edecd7d64cebe979329a4a1acb873e30fa9f3bb47469deebca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3231702c5fcba9e516315148b1d002bd8a992b023a9c9d792e319e707c3fc49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa271a60946b01b795002384e6de6aec40e0b7183bb52210be9ff385845f4f75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c53dca7b80ae751d1b41730be17e01a437cfca9a1118360f41566ed52434150"
    sha256 cellar: :any_skip_relocation, sonoma:        "197800b9dd379f80b3d7e9bbe6a0a38a7099f986335e255593d594764915596a"
    sha256 cellar: :any_skip_relocation, ventura:       "1dda2642149f8c66b3e682146eaf9a77c91eef6304ac7d50059842c68be1be76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0610976a50463a6df9351c0db91b583dd1032cddefa4670f5c86096149e1a1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8342bcb2b1b190c7f4278e29b2e91301024dbe884da0d865b756dc5ddd9b8f6e"
  end

  head do
    url "https://github.com/commercialhaskell/stack.git", branch: "master"

    depends_on "ghc" => :build
  end

  depends_on "cabal-install" => :build

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
