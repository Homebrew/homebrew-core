require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  revision 2
  head "https://github.com/commercialhaskell/stack.git"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/v1.1.2.tar.gz"
    sha256 "8f43d69a00a8861b156705a634e55179524cefbd98e6c29182e7bdcb57d8b3be"

    # Fix build with newer cabal
    # Due to per-component cabal_macros.h, the executable code doesn't have
    # access to VERSION_hpack
    patch do
      url "https://github.com/commercialhaskell/stack/commit/93cedb7ce20d1fcc4f46d4b0b38b7842d44bad20.patch"
      sha256 "378a30878cc25e3b1580e24f832ed171c4fb67786dd46a5d2653863c1b01ea3f"
    end

    # stack.cabal: adjust dependency bounds
    # Allow generic-deriving < 1.11 and monad-unlift < 0.3
    # https://github.com/fpco/stackage/issues/1467
    patch do
      url "https://github.com/commercialhaskell/stack/commit/3a7122e61b0263f44b35761ff093d134f9166899.patch"
      sha256 "e188b457883da73888119772f308828f8f34090f294afabf9d49f7072c365ab3"
    end

    # Have `stack ghci` skip build if there are no targets
    # https://github.com/commercialhaskell/stack/issues/2176
    patch do
      url "https://github.com/commercialhaskell/stack/commit/0b58282cd97be66b22019832eb5906c29b4c8971.patch"
      sha256 "6a2f52e6b389ad3e17892ea584bef46e07ad9a0c7598cd857832f650eb6464ac"
    end

    # Remove debug info from default output
    # https://github.com/commercialhaskell/stack/issues/2175
    patch do
      url "https://github.com/commercialhaskell/stack/commit/0060443d53673ee035e1a755b7082b892a47cb56.patch"
      sha256 "6e91794e3cdebb3cafa74f58a4338c867cb9cd981eb500bdf8e545ba23725d3e"
    end

    # Bump GHC-included package upper bounds
    # https://github.com/fpco/stackage/issues/1476
    patch do
      url "https://github.com/commercialhaskell/stack/commit/f848ceb16b147636e112068d346267b1de661c1b.patch"
      sha256 "d7229380ec9c4a6de8abaeaf58afab71dfb434e5c65ed20cde1fb35c2dd4f306"
    end

    # Restrict persistent-sqlite < 2.5.0.1
    # https://github.com/commercialhaskell/stack/issues/2182
    patch do
      url "https://github.com/commercialhaskell/stack/commit/b388d11e2013c3e755573c44e40788461a26116f.patch"
      sha256 "dfcf888ff715a4843fbd4730912b640445e28a4440445d6198112acdb89f56ed"
    end
  end

  bottle do
    sha256 "891fa9dc2ac357980b6140d5771d60b5056d7845ad03b580b1206a5234cb8e76" => :el_capitan
    sha256 "e1c3e21c829930cad1870bada9a90969bf32ee866bb6379c1bc8004759cb0b54" => :yosemite
    sha256 "a3ab294bf25d6424ecdc70b7eee2f2928674e51098a73c4eef6ae746fb6f5eb4" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
