class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
  sha256 "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5573988c2215550bebe8c27b521f5b1a0942d66da9f151f3d9770d9b7a8638e2" => :mojave
    sha256 "c2df115f346bdf5702951d9ad0107f9cbfd424dfb643266c5cf38582098c71a0" => :high_sierra
    sha256 "46fb8269a86b79eb2d1426432cd5bbdefeac9e7d5414c1a161d912a403708403" => :sierra
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
