class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.0/cabal-install-1.24.0.0.tar.gz"
  sha256 "d840ecfd0a95a96e956b57fb2f3e9c81d9fc160e1fd0ea350b0d37d169d9e87e"
  revision 1

  bottle do
    sha256 "cd1b2478062f3632b186722a8cd92b3a664051fbc974f0e30b39d2c1d994340c" => :el_capitan
    sha256 "ccca2644fbf124d5991154ce9d320d45832f877c00f68de6357ccdf502f6ae61" => :yosemite
    sha256 "bab61fbb71e68fda371aaab615331dcef51505dfecb0d1428fc47d60be79c737" => :mavericks
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  # disables haddock for hackage-security
  patch :p2 do
    url "https://github.com/haskell/cabal/commit/9441fe.patch"
    sha256 "5506d46507f38c72270efc4bb301a85799a7710804e033eaef7434668a012c5e"
  end

  def install
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
