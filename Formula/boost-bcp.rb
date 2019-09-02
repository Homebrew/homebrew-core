class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
  sha256 "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8bc92d0fd7a062612c2e19ea8993b30ba583fb92a4bc45467092dca5e93bca4" => :mojave
    sha256 "dba120d947a05ceed5a225c23a2a67dd97c4fbffcf45e45c19bd47cad0730a2a" => :high_sierra
    sha256 "d2f3b79542144ebc71b239084a5bab68d6aef7637d7545fa8e70d14eea5e98ee" => :sierra
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
