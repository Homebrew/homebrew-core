class CabalInstallAT34 < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.4.0.0/cabal-install-3.4.0.0.tar.gz"
  sha256 "1980ef3fb30001ca8cf830c4cae1356f6065f4fea787c7786c7200754ba73e97"
  license "BSD-3-Clause"

  keg_only :versioned_formula

  depends_on "cabal-install" => :build
  depends_on "ghc"
  uses_from_macos "zlib"

  def install
    cd "cabal-install" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
