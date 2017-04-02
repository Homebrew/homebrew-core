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
    sha256 "624a68d132c3f89e9b4f5b089915b40aa612577097d13dd64ac9e2310a50050c" => :sierra
    sha256 "e71e0d344e7e23d407c4bba77289083d8328f9a1e93c733e1f1c1b88f3c37745" => :el_capitan
    sha256 "086d41db9d06a816a2b9ec44d2d580e2bba078abc5fc9863dfbc948ee263434a" => :yosemite
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
