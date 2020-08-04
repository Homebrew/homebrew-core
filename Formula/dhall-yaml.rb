class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.1/dhall-yaml-1.2.1.tar.gz"
  sha256 "aa68f6dc6ba5d6f10c389bf3ca741034774a55dbd2957d30895ffcc84552e8a2"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e267f158c3fcb8f5442ab893aae92e2e7051023085b5f207271b4b846e26e4e" => :catalina
    sha256 "54c3ca079dee8bbabffe6247f55ec30591f0a3facc8a76aeeec841423da63926" => :mojave
    sha256 "f82cd5dc0c3b8bca94dedfe0a709ea5dab38f7e5ab110df504ead04b8ec7d278" => :high_sierra
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
