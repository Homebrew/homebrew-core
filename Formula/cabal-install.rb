class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.0/cabal-install-1.24.0.0.tar.gz"
  sha256 "d840ecfd0a95a96e956b57fb2f3e9c81d9fc160e1fd0ea350b0d37d169d9e87e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "00e180ab005c6b35120dec1a44615fc1b2c55a3f7246921e32ce857fdc12bf33" => :sierra
    sha256 "8a7c7e1b9603df8770455d9cda8b98018591e8218971a2a73928aba122586ba7" => :el_capitan
    sha256 "5eec25c84652f5516e369f338945ea5a7807ae509680a752bf39c0c379374b40" => :yosemite
    sha256 "065cd05eeb2f0b5a1cde05c12dd3835af5bca08f5dea0beef6b63fcaeb330cce" => :mavericks
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
