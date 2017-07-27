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
    sha256 "70de8a219905be9a744387b0dd782cc922bc374daa1e790aeefe245ccfd40243" => :sierra
    sha256 "af3c4b5476df87621310693be0592f680ee7d84ffc16ac1eb4702f4fc59067f9" => :el_capitan
    sha256 "de1af621d53c04d5bf1c9e92f40ab7ef0d513d57568bdcbc231437fdaa57939f" => :yosemite
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
