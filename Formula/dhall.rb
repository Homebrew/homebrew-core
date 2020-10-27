class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.36.0/dhall-1.36.0.tar.gz"
  sha256 "9207c8becbbc1890568b861d35a623e10451feea0e0d34b317ec77966b6f8b04"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "02331205e3f27d14f8c5fe108bbd69497c01d7b2e795c92158fa5c0cbe628913" => :catalina
    sha256 "53dacefb2ccf077ee0b8545c33da906aae9fa262d306da709f9eb13c38aae7f5" => :mojave
    sha256 "f332b105f50c549fe3e96e9b077d2c076e47e312397bdf48f70bb68990b27c02" => :high_sierra
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
