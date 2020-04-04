class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz"
  sha256 "a0555e895aaf17ca08453fde8b19af96725da8398e027aa43a49c1658a600cb0"
  head "https://github.com/haskell/cabal.git", :branch => "2.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5605a9a7cef6e7615126345ba43b690f16c80aa853c31cc394b0376c847f6def" => :catalina
    sha256 "07896a69965d55253b30aa20470090245ab523a6ee22efe6b10d3b0ffb4a16e4" => :mojave
    sha256 "72616fee2252d33d00e79ecd1778f0f8abffd71e339482dda5927c10d2574746" => :high_sierra
  end

  # Temporarily depend on older GHC for building cabal-install itself, due to
  # https://github.com/Homebrew/homebrew-core/pull/46828
  # https://github.com/haskell/cabal/issues/6327
  depends_on "ghc@8.6" => :build
  depends_on "ghc"
  uses_from_macos "zlib"

  def install
    ENV.prepend_path "PATH", Formula["ghc@8.6"].opt_bin

    cd "cabal-install" if build.head?

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
