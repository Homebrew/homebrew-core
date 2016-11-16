class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.1/cabal-install-1.24.0.1.tar.gz"
  sha256 "09f5fd8a2aa7f9565800a711a133f8142d36d59b38f59da09c25045b83ee9ecc"
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "874a605b03477af53f483fdb962f20905521d1e3f2d166536c54d260c7c24af5" => :sierra
    sha256 "a19398985f66a962025006ed3463ffa5e4f93fd740878a6400f25b1c63d248e0" => :el_capitan
    sha256 "bc3df0adff1bac34e14d65d55521df0e0f5b40ca43d969da4058fe4db3cc6e86" => :yosemite
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if build.head?

    # Fix "'Distribution.Simple.Configure' does not export 'computeEffectiveProfiling'"
    # Equivalent to upstream PR from 16 Nov 2016 https://github.com/haskell/cabal/pull/4117
    inreplace "bootstrap.sh", 'CABAL_VER_REGEXP="1\.24\.[0-9]"',
                              'CABAL_VER_REGEXP="1\.24\.[1-9]"'
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
