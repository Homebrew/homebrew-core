require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v1.9.3.1.tar.gz"
  version "1.9.3.1"
  sha256 "f3a076692b5ba88f4c671ba91a2212a6a67b3421ec684109bf9e1c659ba4de2e"
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
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.9.3.1/stack-lts-12.yaml"
    version "1.9.3.1"
    sha256 "12f11d6cc4d9c802c8e0076d3836ebb01d964f9547537108176d65e5695f6f4a"
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
