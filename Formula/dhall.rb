class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.37.1/dhall-1.37.1.tar.gz"
  sha256 "8d08f9fd1b92bbb24dcc7da27aa32f824b256c1b446749535c8ff140b856179b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eafc8a4caf3bada13d12c5f4a9c680997a73cddf7f733a30dd853ffd784268ad" => :big_sur
    sha256 "9dcb181c785b3b7276e279a74e678d464bcacdfb49751af72a05c999d13ac386" => :catalina
    sha256 "075b8a9679b8c93f2920ce096cbfacdb4c97cf0ac69f1eaaba96b76a1484813f" => :mojave
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
