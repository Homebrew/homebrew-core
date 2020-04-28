class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_73_0.tar.bz2"
  sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "206a46348fb75f752b6a7166c4a549888208f62b1d57d4aedc0abacb71e51e3d" => :catalina
    sha256 "2d4b85c52ab0dceed07984c4c6f9e35c0f7dbcbb73528a5993177c3a94457ebc" => :mojave
    sha256 "fde3e6baae64ff2297e6babed41147071065c4ac0f37c2ea5dd6530f49865582" => :high_sierra
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
