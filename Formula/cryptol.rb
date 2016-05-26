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
    revision 1
    sha256 "029b27a757693e94ecc6a5edf73686577dcdb258cfe1e6544a9d6764c0c7e2da" => :el_capitan
    sha256 "f6189a54a06fb8a7e91b1526cdb1b02cd0b5c0638421a7bcfbbcd12bf6aceb2b" => :yosemite
    sha256 "f29fb9813f77732f71a1d9e78fc5615f97b15847b894453afe4bd746a17befc5" => :mavericks
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
