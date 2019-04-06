class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2"
  sha256 "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e972b5ee3865693fc5950c9eaae9d26167f68c86bae9abb5a4cfb9151a2f901b" => :mojave
    sha256 "68b45debcb736171b92b851c2e999d4f518b1f11c9c721b90127f530f7e00b26" => :high_sierra
    sha256 "8e616d83e7a411b2737e55a4300597dcc4e1c5200bf4b82cb16e17bb4e83df92" => :sierra
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
