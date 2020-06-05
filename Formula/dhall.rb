class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.32.0/dhall-1.32.0.tar.gz"
  sha256 "17a47b3b640da7334c76a4fee05e9c0aa6073ee6822fb97f6cb79851e002b2c6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "30d39921c9e31a6a543d724052ec2c7931dbb6c4a76c8cf0435e375be94e50de" => :catalina
    sha256 "cf34d8d789a1e2aa76e330f5fb9aa8fc74b9fbbcce5e6120efe15ca3caa069e7" => :mojave
    sha256 "9141868a7ed6bb7a80a61e2082ad1c7f3551a1a3dc3f36d48903bfbda6f889a7" => :high_sierra
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
