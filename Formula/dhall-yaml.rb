class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.9/dhall-yaml-1.2.9.tar.gz"
  sha256 "8637b4e78b60a9318d17ffe99a45a9931886e0a4f5e99922d2b246187196c93e"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8dd55ac7cc30a3956d0a70572ad5677436b4e70d8ade82a781b72c88217dd44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7001df466b1aee72cc5b489d66b744b6a4c904bc8b05349af7e0c0a4ea0b960f"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3006edca87e012f87d933cf87b7d3f7694cc1a9cedf5a1c3a93b09bca1d50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c796a7a8b7210d51a26ad45e1713dfb0128d1e88cc4c2efcadc9c5fa7d5f19c7"
    sha256 cellar: :any_skip_relocation, catalina:       "a7dbf68429b1fb9d6e8b15baf8b75b290772803e1efa43f4036d267be8b69e67"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
