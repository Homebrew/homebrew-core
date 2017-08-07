class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.0.0.0/cabal-install-2.0.0.0.tar.gz"
  sha256 "5f370bac2f18f0d96f525e33d723f248e50d73f452076d49425a752bba062b2d"
  head "https://github.com/haskell/cabal.git", :branch => "2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f34d74f73ac4ec578802c56b7fe07bbc9eb88434671980b6a7a18cff4dfa264c" => :sierra
    sha256 "5c651e3af3ce68a8805fbbc77601e3b270f632728da7fa345cbdd48c9f980c76" => :el_capitan
    sha256 "85096c8636875906aae069a2e46dba78c393715381ca2ecfe44848e88354fe84" => :yosemite
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
