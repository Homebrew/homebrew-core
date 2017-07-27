require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.5.0/cryptol-2.5.0.tar.gz"
  sha256 "910928617beb1434ad5681672b78ede5dda7715b85dcb8246fa8d9ddb2261cf1"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "c0a77f0e95bc712c95c7faa5ef646eb845bba322e7417e354b0f5a2549991ecd" => :sierra
    sha256 "dc77b0bceac759f51ea15df8ac8f21157f1b5370ad590d74073190e74d2032d0" => :el_capitan
    sha256 "1771ed234b8889a79618847eee03c2e748496c37d56f4e2336a5be8a8cb89692" => :yosemite
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build
  depends_on "z3" => :run

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
