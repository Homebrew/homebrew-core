class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz"
  sha256 "2ac8819238a0e57fff9c3c857e97b8705b1b5fef2e46cd2829e85d96e2a00fe0"
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1b1fec0cd2a4f9bcb9a55c46bd85ca861b88870f39cfaa293c474426b3948af" => :sierra
    sha256 "1321d967350535e1b8547ab1b482eb92b253c00f4befc62adff41c77a6428b70" => :el_capitan
    sha256 "b0855053e292dd0cf0377011c433491acf05a13a97e4cbf6fd5c6a19303232d4" => :yosemite
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
