class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.33.1/dhall-1.33.1.tar.gz"
  sha256 "53c0c3af567769286c31d13b9a8e98af3600ac6164970e78b70f78f80bc4869e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bdd0d309ff3df40a53e73e60c36787f3a91db38c3e38d0600dcb403485cd88d" => :catalina
    sha256 "6275cdd1a489983f8d82b8350610c2f1e234d3edcb5caccf0a8c396841990b69" => :mojave
    sha256 "e8c49447e402afbc6e063b95eefe236e8aeac62d060f7c7f0c3f8af8814376c5" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
