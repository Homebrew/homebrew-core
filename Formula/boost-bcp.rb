class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_72_0.tar.bz2"
  sha256 "59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "206a46348fb75f752b6a7166c4a549888208f62b1d57d4aedc0abacb71e51e3d" => :catalina
    sha256 "2d4b85c52ab0dceed07984c4c6f9e35c0f7dbcbb73528a5993177c3a94457ebc" => :mojave
    sha256 "fde3e6baae64ff2297e6babed41147071065c4ac0f37c2ea5dd6530f49865582" => :high_sierra
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
