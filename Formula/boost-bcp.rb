class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2"
  sha256 "a547bd06c2fd9a71ba1d169d9cf0339da7ebf4753849a8f7d6fdb8feee99b640"

  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b04e4f16118f1f9c1c955e1cd9cfbd70a7223d3cfe9d4eeb821231a9b62b44ce" => :el_capitan
    sha256 "1dafec2ea159151006a5615ad710c61760bf3daad8f98d4fed905e198073e0fc" => :yosemite
    sha256 "56e649ee9c17b6defb825e6577c009493ed7c463110c43ee0127bc1643c37c13" => :mavericks
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
