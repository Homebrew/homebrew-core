require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.9.0/cryptol-2.9.0.tar.gz"
  sha256 "2bcbf4ad6c1679a17f47467bf6eab250deea8e5125c53535c44afa4af525bd2f"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0def1bdbc98588cd583352d774d31402ee01b1bfc980391ad035dc2c78625e5d" => :catalina
    sha256 "37883057748d5d1fa952bd76430956821a9cd92a254c3ac58d87ef72152edfdf" => :mojave
    sha256 "b2afda7c0df0359122b35280a3bd659d8f2697fd4b51677c3834e01dc67e4e30" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    install_cabal_package using: ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
