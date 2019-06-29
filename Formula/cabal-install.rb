class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.4.1.0/cabal-install-2.4.1.0.tar.gz"
  sha256 "69bcb2b54a064982412e1587c3c5c1b4fada3344b41b568aab25730034cb21ad"
  head "https://github.com/haskell/cabal.git", :branch => "2.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c9ad9914b483ffb64f4449bd6446cb8c0ddfeeff42eddde9137884af3471825" => :mojave
    sha256 "a2f4ba064479e169fcc615f924758c8c7ee9f54a8ba2cd9569f19550e7394951" => :high_sierra
    sha256 "f0b7ed1302d197f84eaedc7ae1a3ad8099fe3b0ed02fb5d03590caf3c8e1627c" => :sierra
  end

  depends_on "ghc"
  uses_from_macos "zlib"

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
