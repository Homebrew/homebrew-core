class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.bz2"
  sha256 "beae2529f759f6b3bf3f4969a19c2e9d6f0c503edcb2de4a61d1428519fcb3b0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b880fac924f096f80a44edc80df91b130dfd15d4c09eeb5d427e9d5ddeb2ce" => :sierra
    sha256 "020a9587f0332a7158cef848453337e57fb33c6d8400f48c1e178875e19e99ff" => :el_capitan
    sha256 "b1a68e182ad4d4c40fbaf987d3b47ba9086ce5b2ed41459f57da4724b6c366cf" => :yosemite
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
