require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.6.1/stack-1.6.1-sdist-1.tar.gz"
  version "1.6.1"
  sha256 "25a5fc6b0094b82fd66137caaddc19fe51c2e96ba2471713133cd9187b60fbae"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9a68185939e59654c368c7a9a3fbad0739fa46b3c3b0828798dcbdbe690327f" => :high_sierra
    sha256 "06ef012cd3eb0bd07cae75431b198a3cad8e5c0ebd26d01667a2046ae95c61a0" => :sierra
    sha256 "cc998d5058af92414d81209cd9045480d0ee28eddcebd84ae048d6ff8f61cf49" => :el_capitan
    sha256 "3d681f2af9240ef71c0e468954c5fbf05cd1b88b8a22d575b7a3371ce7639ad3" => :yosemite
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc@8.0" => :build
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
