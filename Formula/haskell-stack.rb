require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.6.3/stack-1.6.3-sdist-1.tar.gz"
  version "1.6.3"
  sha256 "e3fdd37f36acec830d5692be4a5a5fcb5862112eebc4c11f6c3689ec86dba49b"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "467b18e7f2b1a040152a07c64e5a0ea513f1292f9f629f5803c7c75b521b8c52" => :high_sierra
    sha256 "eeeb491a8e5f52d032181c2acdf07e3f55397fe1e66c052c992f85bc2352e238" => :sierra
    sha256 "85bce10464a320b4d9b6e7e5edffaa24b6deef66b3214be68b63bfe65eb02924" => :el_capitan
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove when stack.yaml uses GHC 8.2.x
  resource "stack_nightly_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.6.3/stack-nightly.yaml"
    version "1.6.3"
    sha256 "55e15c394946ce781d61d2e71a3273fed4d242a5f985a472d131d54ccf2a538c"
  end

  def install
    buildpath.install resource("stack_nightly_yaml")

    cabal_sandbox do
      cabal_install "happy"

      if build.with? "bootstrap"
        cabal_install

        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize

        system "stack", "-j#{jobs}", "--stack-yaml=stack-nightly.yaml", "setup"
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
