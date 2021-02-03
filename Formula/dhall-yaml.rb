class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.5/dhall-yaml-1.2.5.tar.gz"
  sha256 "8e5780a38db78d1e0e9edba4715b0457805a050132081ae6cf9e9051d0255d39"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3087b77065c8fa639d7a93694cf10bea6eef7d047456a3298bbbe50598114b20"
    sha256 cellar: :any_skip_relocation, catalina: "362fb816ee4371e2fba7c5671c44c185a4782006e5318793ffc91306a461636d"
    sha256 cellar: :any_skip_relocation, mojave:   "7559e67690e98b4b97d338d2483e3563de1268e458e8b3635779afb37dcf6a86"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
