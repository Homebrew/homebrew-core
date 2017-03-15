require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.4.0/stack-1.4.0-sdist-0.tar.gz"
  version "1.4.0"
  sha256 "edad1b32eb44acc7632a6b16726cd634f74383fd1c05757dccca1744d1ca3642"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c13c44920816c770a1005c28b5ac2f203527ed5a81dc1825f3000120b2f029d" => :el_capitan_or_later
    sha256 "fffa645a858c5c53107f225582b727651fc78c6f392217443ec5beba952d35e1" => :yosemite
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  # Remove when stack-8.0.yaml is the default
  resource "source_archive" do
    url "https://github.com/commercialhaskell/stack/archive/v1.4.0.tar.gz"
    sha256 "595d311ad117e41ad908b7065743917542b40f343d1334673e98171ee74d36e6"
  end

  def install
    cabal_sandbox do
      if build.with? "bootstrap"
        cabal_install

        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        ENV.deparallelize
        jobs = ENV.make_jobs

        if MacOS.version >= :sierra
          (buildpath/"source_archive").install resource("source_archive")
          cd "source_archive" do
            system "stack", "-j#{jobs}", "--stack-yaml=stack-8.0.yaml", "setup"
            system "stack", "-j#{jobs}", "--stack-yaml=stack-8.0.yaml",
                            "--local-bin-path=#{bin}", "install"
          end
        else
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      else
        install_cabal_package
      end
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
