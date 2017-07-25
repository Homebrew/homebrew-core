require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.5.0/stack-1.5.0-sdist-1.tar.gz"
  version "1.5.0"
  sha256 "de146a503924137d8ab2853a40178abc7fbaa4707824afe895063e42ec603c4d"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "624a68d132c3f89e9b4f5b089915b40aa612577097d13dd64ac9e2310a50050c" => :sierra
    sha256 "e71e0d344e7e23d407c4bba77289083d8328f9a1e93c733e1f1c1b88f3c37745" => :el_capitan
    sha256 "086d41db9d06a816a2b9ec44d2d580e2bba078abc5fc9863dfbc948ee263434a" => :yosemite
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      if build.with? "bootstrap"
        cabal_install

        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize

        system "stack", "-j#{jobs}", "setup"
        system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
      else
        install_cabal_package
      end
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
