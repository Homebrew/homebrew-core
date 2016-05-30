require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.1.2/stack-1.1.2-sdist-2.tar.gz"
  version "1.1.2"
  sha256 "8197e055451437218e964ff4a53936a497a2c1ed4818c17cf290c9a59fff9424"
  revision 3
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "4ee81138d47a78fb6cd416491d1c6f1f9c610473870dcba8617c6625d82b7d20" => :el_capitan
    sha256 "a7f3d96de72d4d0c5ce3afcc25a5de0eabccf8ccc803f04c9061ee68158a649e" => :yosemite
    sha256 "0cb19aded681b0b4a002236f0e0ed992e229c1a5598adf2748a5272328dd5b41" => :mavericks
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
