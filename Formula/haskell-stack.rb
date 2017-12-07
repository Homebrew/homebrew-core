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
    sha256 "467b18e7f2b1a040152a07c64e5a0ea513f1292f9f629f5803c7c75b521b8c52" => :high_sierra
    sha256 "eeeb491a8e5f52d032181c2acdf07e3f55397fe1e66c052c992f85bc2352e238" => :sierra
    sha256 "85bce10464a320b4d9b6e7e5edffaa24b6deef66b3214be68b63bfe65eb02924" => :el_capitan
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
