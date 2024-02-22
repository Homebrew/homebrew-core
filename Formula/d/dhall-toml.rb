class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.3/dhall-toml-1.0.3.tar.gz"
  sha256 "00a9ece5313c8b5ec32516e0b1e326b63062f9b7abb025a084bda5b69cae2935"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-toml", "1", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-toml", "None Natural", 0)
  end
end
