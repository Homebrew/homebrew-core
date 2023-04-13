class DhallToml < Formula
  desc "Dhall to TOML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.2/dhall-toml-1.0.2.tar.gz"
  sha256 "d027636c5492a04cfe87117fbb8a3f1e80c6145e7c05fccc2ad5eb754780f9f9"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-toml", "1", 0)
  end
end
