class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2"
  sha256 "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0"

  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "065c4789aa949ae64eb2bed0df14f5817abcb5ad628b67919fe8e6ae64f36af2" => :sierra
    sha256 "43f9adea3dff5da4d8f8e23a7e0823e0e712f60b9196a418b315e957ff109dcd" => :el_capitan
    sha256 "87289c469edfd5fb2c348e4c05c7cd7131f7f34b0d3b017ad970df03a956d7f9" => :yosemite
    sha256 "a1e8bf11a68d5f45be408594951409b8e595501f08d950920cda3404a1880d4c" => :mavericks
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
