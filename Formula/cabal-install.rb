class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz"
  sha256 "2ac8819238a0e57fff9c3c857e97b8705b1b5fef2e46cd2829e85d96e2a00fe0"
  revision 4
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "f34d74f73ac4ec578802c56b7fe07bbc9eb88434671980b6a7a18cff4dfa264c" => :sierra
    sha256 "5c651e3af3ce68a8805fbbc77601e3b270f632728da7fa345cbdd48c9f980c76" => :el_capitan
    sha256 "85096c8636875906aae069a2e46dba78c393715381ca2ecfe44848e88354fe84" => :yosemite
  end

  depends_on "ghc@8.0"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if build.head?

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    ENV.prepend_path "PATH", Formula["ghc@8.0"].opt_bin
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
