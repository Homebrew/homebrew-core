require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.1.2/stack-1.1.2-sdist-2.tar.gz"
  version "1.1.2"
  sha256 "8197e055451437218e964ff4a53936a497a2c1ed4818c17cf290c9a59fff9424"
  revision 3
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8e2343689c99d85bb1c930d83cbafc8ca7be4fc64faaeb844771a1511a0ff3d" => :el_capitan
    sha256 "fe0aa6086ec90d711ebf0cd0169f5a3dc76f6f1a8c81b357ba6c81d0a22a86af" => :yosemite
    sha256 "06a004b35c817fc17b0496aa06a886d5d1a69e9436bb9e8aa5e039f3148212c2" => :mavericks
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    if build.with? "bootstrap"
      cabal_sandbox do
        cabal_install
        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize do
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      end
    else
      install_cabal_package
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
