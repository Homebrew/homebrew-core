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
    sha256 "b72341b0d1e3a5364ccfd3cef0b0e9da1ca072be8ada87611cb7f5133f7cdc48" => :high_sierra
    sha256 "7f157b8e95945f5bc607d1f87436ef50b92bae13d3e12419c5f8349f02233dc3" => :sierra
    sha256 "263ca39d2d0a3b8af80212b0359c31ac7ba2829da8bbf2c20023081a38afbdeb" => :el_capitan
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
