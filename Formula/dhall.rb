require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.29.0/dhall-1.29.0.tar.gz"
  sha256 "c73e59717ff15707c77f3ff582f5adf68fc7abc68dbf70aa77ce65333637e7f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d643e1fe24f03c105280c5b57e50db38fa41479de9a2774354ca6c4a9bd789" => :catalina
    sha256 "a9f4ac6ca8032dafa6bc3e7acd9c158f340b59925363842b6695a18b3db72c2e" => :mojave
    sha256 "9cf97414490d19ecbf757a3b77e178c64fc73c59d1bb66a5d4c52dce90324e2f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
