class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz"
  sha256 "a0555e895aaf17ca08453fde8b19af96725da8398e027aa43a49c1658a600cb0"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.2"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7fbdab393a7e9c70d4da3246152d852eb919f1fb6fd45eda6ab9b0326b3516fe" => :catalina
    sha256 "11e3cd8f442d083b175f8d4e043f5d232c2593fc8c606551ef65b41b988b9748" => :mojave
    sha256 "2946e5b36632d7e33e1312c0597d4858479748ee94eb1a52df9f4869c87eb2a7" => :high_sierra
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  # Update bootstrap dependencies to work with base-4.13.0.0
  patch :p2 do
    url "https://github.com/haskell/cabal/commit/b6f7ec5f3598f69288bddbdba352e246e337fb90.patch?full_index=1"
    sha256 "f4c869e74968c5892cd1fa1001adf96eddcec73e03fb5cf70d3a0c0de08d9e4e"
  end

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
