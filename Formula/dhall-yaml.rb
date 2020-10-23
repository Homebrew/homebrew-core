class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.3/dhall-yaml-1.2.3.tar.gz"
  sha256 "c3551fcc5685d65211aed5ec0d01ff3c2c547506261941fd25cb451f725e82d8"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "51905909d522b9e01a8171268699370a7c2d55f1179d97ea591a0209861db237" => :catalina
    sha256 "5862dc53068863c50c2ea96aaf58d903c3607d22cf4079d13ed24eb637b4fd10" => :mojave
    sha256 "f115af83fb125b0ca0f6a2c2cb2ff7c09d2198c585c2e01421d19034dc352393" => :high_sierra
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
