class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.2.0.0/cabal-install-2.2.0.0.tar.gz"
  sha256 "c856a2dd93c5a7b909597c066b9f9ca27fbda1a502b3f96077b7918c0f64a3d9"
  head "https://github.com/haskell/cabal.git", :branch => "2.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "d465bacd79a08428a9540be23777d9977dd8b9240ddcf0b095b88cb86f19452e" => :mojave
    sha256 "e76f7025723a0144a171815cfd5fd3287625da5c0c15590cc9d5ebacc9091bd7" => :high_sierra
    sha256 "d423ee9e0be77ec1b00900307ba413bead22e30f7d75287dbe68436b15955406" => :sierra
    sha256 "5fb901d51642557d30063ab37c5324cf4b317ed7f4c8714a78dfa0b935f20f74" => :el_capitan
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
