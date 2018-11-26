class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.4.1.0/cabal-install-2.4.1.0.tar.gz"
  sha256 "69bcb2b54a064982412e1587c3c5c1b4fada3344b41b568aab25730034cb21ad"
  head "https://github.com/haskell/cabal.git", :branch => "2.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "874a6a0dfa5653320e4986c752f188c33eb7b73e64078f66d02a9506a8e1995d" => :mojave
    sha256 "85a9f41433e5e530e94bf3cc7c43dbf367d789656c2737fdcf894126e343d61e" => :high_sierra
    sha256 "9422f5c3a54c09076faede3a94c396cb52b1d31744497185ebca6736704a9315" => :sierra
    sha256 "53c944614e215fac004e14b3b43a0d8201f58054ad59f782677278067bfe7909" => :el_capitan
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
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
