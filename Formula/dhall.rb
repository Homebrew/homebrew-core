class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.38.0/dhall-1.38.0.tar.gz"
  sha256 "490854a22a158f675ff7e98aeb33f88faeba3f93923e263420c6d37b628add45"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3de60b380ab466d50c1629884c233c467a30e71c3301ff3dd3ceaaa2caada8c6"
    sha256 cellar: :any_skip_relocation, catalina: "91fa91f7204130ebf78c84cc250fa4d26bc4f32c4c72c455d7f8702977548ba2"
    sha256 cellar: :any_skip_relocation, mojave:   "bb548f90ea5dc33b1dc86280e62d95e69ac3b18b07fdc68af58138dc28b3b701"
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
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
