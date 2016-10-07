class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2"
  sha256 "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0"

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
