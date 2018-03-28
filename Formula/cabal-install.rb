class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.2.0.0/cabal-install-2.2.0.0.tar.gz"
  sha256 "c856a2dd93c5a7b909597c066b9f9ca27fbda1a502b3f96077b7918c0f64a3d9"
  head "https://github.com/haskell/cabal.git", :branch => "2.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f2436d90d102a0b213ff852bfda988853faee571fc50d91831a3feefc7e671" => :high_sierra
    sha256 "2ad3ac7ef020067a14e988d74823018b2be633d7af53d5af435ae1fa795dbd0d" => :sierra
    sha256 "1d194910abf09edaa50a09c8c1732f2801ed7efd21b06cb982c0d90a990d5b56" => :el_capitan
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
