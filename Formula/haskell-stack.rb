require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v2.1.1/stack-2.1.1-osx-x86_64.tar.gz"
  version "2.1.1"
  sha256 "f4af329419fb6ee9655b22db04d72a35a5a225e78bdcc605d78334a72c8c2332"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e77734678c0a9bb402373a53e1c67663cfd5160f8dd2be3e3a16a569ae5a9a48" => :mojave
    sha256 "ce65fc3575740104c9a99bd8797ac10e8724d8d36c80326251343ed68ab965c0" => :high_sierra
    sha256 "3c278a54d4e0d829ab89f018e49d1e69721034a51b56af1435738a5b20e9f5b8" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Build using a stack config that matches the default Homebrew version of GHC
  resource "stack_lts_12_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v2.1.1/stack-lts-12.yaml"
    version "2.1.1"
    sha256 "63b1937cb355c086e15c9da99021165b6e16d49620b6747d358e137e7b3fe793"
  end

  def install
    buildpath.install resource("stack_lts_12_yaml")

    cabal_sandbox do
      cabal_install "happy"

      cabal_install

      # Let `stack` handle its own parallelization
      # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
      jobs = ENV.make_jobs
      ENV.deparallelize

      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "setup"
      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
