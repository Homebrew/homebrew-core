class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.37.0/dhall-1.37.0.tar.gz"
  sha256 "1d602b52c5e7c15411518a48cc22f0895226dd1ce77118eb0a6e968ab448c088"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c0f806e50e86f3292e3ad56680733fbcb819af9e1c3ee8ef71aca221aba409f4" => :big_sur
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
