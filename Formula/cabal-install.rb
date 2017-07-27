class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz"
  sha256 "2ac8819238a0e57fff9c3c857e97b8705b1b5fef2e46cd2829e85d96e2a00fe0"
  revision 4
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "d26d08a85d812cf89fd64e69b8ab3e28910c2d302ac661a9f572f6782bb06e80" => :sierra
    sha256 "b537288f76b6d125eac1b2a1b0ef3b2140a60ca592fa5f5573bab1a9fcedef9a" => :el_capitan
    sha256 "f58112b5b74e0056013daf2ac47b0f20393904557ff4f994ef5361e0ce3db343" => :yosemite
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
