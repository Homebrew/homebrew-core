require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.9.1/stack-1.9.1-sdist-1.tar.gz"
  version "1.9.1"
  sha256 "2628d0a02cb9d48a41f7b257d2619c8ba2e333cd91df03d0729029da53cf6855"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "848150f9b160487717c4e660bf796a26d38b4d6c33b97084965fe1238f073308" => :mojave
    sha256 "fda2391548b3ff62866e09f584458fa7e4b894273c77024134a99f90b56850e6" => :high_sierra
    sha256 "e02d867825d757031ea0dc945f598b794d097b3398fb202b0de8ba9684198d1e" => :sierra
    sha256 "d303035dc4e8fcdc8d1aecd5c0c56a8db0421cd21cc5d168442289b9d2e10168" => :el_capitan
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove when stack.yaml uses GHC 8.4.x
  resource "stack_nightly_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.9.1/stack-nightly.yaml"
    version "1.9.1"
    sha256 "9a738cb17dc9b3cc3f8ab0f2c26499c2bad824fbc46a371e4b5a0cf8f5f2ba48"
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
