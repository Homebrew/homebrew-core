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
    sha256 "ea66030865cab5c96dd7e2dd7a0fbc43a9d9f014948ca599d97b8378ab2570b2" => :catalina
    sha256 "ec881eed5e8b5fe8c8fdb69e8d30180574963e06ca6be522298a6d16e317a65d" => :mojave
    sha256 "f6239d17c64339c6cf2ba03f5d5f34b2f89b94f175a85f5014f0d6fa844c6b65" => :high_sierra
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
