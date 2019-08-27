class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.0.0.0/cabal-install-3.0.0.0.tar.gz"
  sha256 "a432a7853afe96c0fd80f434bd80274601331d8c46b628cd19a0d8e96212aaf1"
  head "https://github.com/haskell/cabal.git", :branch => "2.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "b18ee2ea7c31be5fa6068f73ba656136f363b7ef4d010ecfe95d78d7b89f9e18" => :mojave
    sha256 "2e6375fa4bd525b2957d2c3ae46f7034649a0d700ef58f2720d1a4c2c43b0d1a" => :high_sierra
    sha256 "b134c0335ad5ef2acee9d11ec855e5b5e44cde3eda343a92a6ebfd2231bed329" => :sierra
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
