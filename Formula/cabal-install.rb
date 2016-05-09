class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.9.0/cabal-install-1.22.9.0.tar.gz"
  sha256 "874035e5730263653c7aa459f270efbffc06da92ea0c828e09ebc04400e94940"

  bottle do
    sha256 "e0aeba6df425d2e6d3c9f40059eeafffc4c7ab50fcf9e8a018a6bafed859c253" => :el_capitan
    sha256 "07c790c32d85cc62230eb35bed0f1ba6c589000f2e7548f1bcd88d087d969e87" => :yosemite
    sha256 "780faa5309f62c7e4cf222c9f7f82f4f2e6b8c3d87e18d45ca2e3ebbb9757347" => :mavericks
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
