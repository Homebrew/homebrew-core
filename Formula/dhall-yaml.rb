class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.6/dhall-yaml-1.2.6.tar.gz"
  sha256 "95c5b984c9714b3f2288f9379a996b7da8acfa4bd24344091468d80e4728ce6c"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "db34193b71b55daf2bf85c70681f79a50f75e16f6c4085b6bd42a9925e730a0e"
    sha256 cellar: :any_skip_relocation, catalina: "e126e3a891a0c5e492a2af446974d4d06a8500ae658b26714cd8e474a1da8da8"
    sha256 cellar: :any_skip_relocation, mojave:   "26300f99283556cf9531aedb46ccc45927ecc603d3b9aa4b2150bd1e775566cd"
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
