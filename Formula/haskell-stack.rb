require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.6.5/stack-1.6.5-sdist-1.tar.gz"
  version "1.6.5"
  sha256 "71d02e2a3b507dcde7596f51d9a342865020aa74ebe79847d7bf815e1c7f2abb"
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

  # Remove when stack.yaml uses GHC 8.2.x
  resource "stack_nightly_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.6.5/stack-nightly.yaml"
    version "1.6.5"
    sha256 "07ef0e20d4ba52a02d94f9809ffbd6980fbc57c66316620ba6a4cacfa4c9a7dd"
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
