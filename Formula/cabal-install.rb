class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.0.0.0/cabal-install-3.0.0.0.tar.gz"
  sha256 "a432a7853afe96c0fd80f434bd80274601331d8c46b628cd19a0d8e96212aaf1"
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
