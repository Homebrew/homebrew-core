class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.11/dhall-yaml-1.2.11.tar.gz"
  sha256 "90ba0e61caeb1f1b671dd5d21ced247d5c761fb9b1c3d7b467c907fbe24b16c7"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8103d97ef51d7a331d4c15b9073e3847e7f9bd3e57a093b6476ebca10b550a99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f85fdec06f8fe38a8b6da9453651f9c07f49889ecaa9c30a31e64598e33774f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d7874a05f1a88499aa8377c693343ea922df26965f6e18b923fb2d5dc363ff20"
    sha256 cellar: :any_skip_relocation, monterey:       "4e970a26b036b0b0f34412c1aa49b5e31e6b5c46e30465dac5ca9c7e332d13ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "cebe8b981ee53551733d158dffd23f483b0dcd108fec9f6078b6add6eb082600"
    sha256 cellar: :any_skip_relocation, catalina:       "1995b281bf300de48db36c0ad04e4f69cf10ea184d4001e8fa1e07ec76a5fa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bff559058b2bef2ecce72d231c8d26128b4dfc433cc5cea935521426304edf84"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
