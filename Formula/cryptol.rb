require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git"

  stable do
    url "https://github.com/GaloisInc/cryptol.git",
        :tag => "2.3.0",
        :revision => "eb51fab238797dfc10274fd60c68acd4bdf53820"

    # Upstream commit titled "tweak for deepseq-generics-0.2"
    # Fixes the error "Not in scope: type constructor or class NFData"
    patch do
      url "https://github.com/GaloisInc/cryptol/commit/ab43c275d4130abeeec952f491e4cffc936d3f54.patch"
      sha256 "464be670065579b4c53f2b14b41af7394c1122e8884c3af2c29358f90ee34d82"
    end
  end

  bottle do
    sha256 "baea71ec45613f8c74f76432cd22a1a45166534e50166d5f6618eea3f14fd61c" => :el_capitan
    sha256 "cceb554a99d0cbca4d9c1253c7afb3ea31b8f6bf0756324af54ce3bc0fa7e582" => :yosemite
    sha256 "28ab78ff34479ee6b8f7e8efc7ae948d5fdc7c67efe0a4e8b783e3766351347d" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

  # Uses the upstream PR from 17 May 2016: "Updated SBV to work with GHC 8.0"
  # First failure without the patch while building sbv-5.11 looks like this:
  #   GHC/SrcLoc/Compat.hs:9:1: error:
  #     Failed to load interface for GHC.SrcLoc
  resource "sbv-pr-219" do
    url "https://github.com/LeventErkok/sbv/pull/219.diff"
    sha256 "c08e4b60de8a88811456feace5aecac19758a34c75715abc0fa17e60bc1f4e18"
  end

  def install
    buildpath.install resource("sbv-pr-219")

    cabal_sandbox do
      system "cabal", "get", "sbv"
      cd "sbv-5.11" do
        system "/usr/bin/patch", "-p1", "-i", buildpath/"219.diff"
      end
      cabal_sandbox_add_source "sbv-5.11"

      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    result = shell_output "#{bin}/cryptol -b #{(testpath/"helloworld.icry")}"
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, result
  end
end
