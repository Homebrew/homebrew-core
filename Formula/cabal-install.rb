class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.0.0.1/cabal-install-2.0.0.1.tar.gz"
  sha256 "f991e36f3adaa1c7e2f0c422a2f2a4ab21b7041c82a8896f72afc9843a0d5d99"
  head "https://github.com/haskell/cabal.git", :branch => "2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b254ac6813d22df46f50e5078273dcc259f727d7855cc749f37017ce8e645e98" => :high_sierra
    sha256 "bd4ead434980525b7a21cebb7f73da9a8c68e6a226bfd85b01abea55f814af96" => :sierra
    sha256 "a093efe37db90411dc87eccaaca4e8245dbd9c46197f44f4d4dd484b1055ec03" => :el_capitan
    sha256 "ce0e79606ebc753b213e8e2a46506bd27e82dacef493452dc31cb445ee4e4e1d" => :yosemite
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if build.head?

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
