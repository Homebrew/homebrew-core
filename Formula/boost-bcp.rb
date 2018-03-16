class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
  sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc03b6b77094b1c4de504b978a4af49b08d26489b408c06dd0b912b9964360a0" => :high_sierra
    sha256 "00e8fd4050ade4c622207a7e41486edfbf8446851772d47422b6dd819e511762" => :sierra
    sha256 "44919a960db5d48027889bcea2571c4cc955043de9d6f597a300104829f4f46a" => :el_capitan
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
