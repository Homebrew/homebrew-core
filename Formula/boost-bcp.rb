class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.bz2"
  sha256 "ea26712742e2fb079c2a566a31f3266973b76e38222b9f88b387e3c8b2f9902c"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1299cbbab53626c4efa71d666c6101584f4a3172bc598f9233dc2afd171eec9" => :sierra
    sha256 "9be9c0871856fc998d0005078874b2be199e804c5cd3e58c45cc3e361a5180be" => :el_capitan
    sha256 "39aedc49dbd5d2b188786016b90d3caec89dc81306edaa3fa9bd00664758136e" => :yosemite
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
