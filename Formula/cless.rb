require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://github.com/tanakh/cless/archive/0.3.0.0.tar.gz"
  sha256 "382ad9b2ce6bf216bf2da1b9cadd9a7561526bfbab418c933b646d03e56833b2"
  revision 1

  bottle do
    sha256 "69b6e6441633e58e2c48483b2bf6122daed6d1dfe3d7ce31525024dc0ce2d4d6" => :el_capitan
    sha256 "49b15946ec65f85e5b94333485ba8a8eee1b7ec6d2f53c4619d894c9aaf3e6a8" => :yosemite
    sha256 "aaa095676d987a4cdfb613ddf4be28fd8ae1eaf4788f85b045fa5711cfecdffb" => :mavericks
    sha256 "8dcb4a2e9c72d22ab96eee8f18ce4f63bd5f28dea6ef586de82865c94cb2fd8a" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # GHC 8 compat
    # Reported 25 May 2016: https://github.com/tanakh/cless/issues/3
    # Also see "fix compilation with GHC 7.10", which has the base bump but not
    # the transformers bump: https://github.com/tanakh/cless/pull/2
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
