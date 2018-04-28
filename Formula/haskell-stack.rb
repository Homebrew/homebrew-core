require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.7.1/stack-1.7.1-sdist-1.tar.gz"
  version "1.7.1"
  sha256 "a548fb549b2b1e539e257732596508e4c3d43e3a9d62bd22ecc19dda67c30ce6"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db238d3a7882f2daf3db591d299a4cdb61aa686dd98689dd067ec5ceb1f238d9" => :high_sierra
    sha256 "89b99c0ecd45ce787072ddebb0bf50abdb131714ff68d83e9d0f0bf67126fa71" => :sierra
    sha256 "3709f279175426311d54a8096dd7058bcd470e7dd8c4164d8cb2d3ef5f1be9f9" => :el_capitan
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove when stack.yaml uses GHC 8.4.x
  resource "stack_nightly_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.7.1/stack-nightly.yaml"
    version "1.7.1"
    sha256 "08cf289b53983b72d88f48004b58a3154728125f7cff174c0364f1dd936c607e"
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

        system "stack", "-j#{jobs}", "--stack-yaml=stack-nightly.yaml",
               "--system-ghc", "--no-install-ghc", "setup"
        system "stack", "-j#{jobs}", "--stack-yaml=stack-nightly.yaml",
               "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
               "install"
      else
        install_cabal_package
      end
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
