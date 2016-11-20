class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.1/cabal-install-1.24.0.1.tar.gz"
  sha256 "09f5fd8a2aa7f9565800a711a133f8142d36d59b38f59da09c25045b83ee9ecc"
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f92816c3fe71d682e60f9f99c07e433afea918cb336837285360a392c691f29" => :sierra
    sha256 "06322e1984dd2ecbdadd192938ca3e077ced5ad7fc132875a3d0974d5510ceae" => :el_capitan
    sha256 "5f2c2e13c80b41d3e088614cddc3e63ff286bb8e9aa31b282b74370671ecd342" => :yosemite
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
