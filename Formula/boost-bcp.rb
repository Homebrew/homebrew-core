class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
  sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c16e424058e32535221951ee4e67cf37804814f476e421a1fd6b63c2a9faa26" => :mojave
    sha256 "95e399c79e9b8a176ae3d9495dac2b3719d8d0a332f4aaeeb94876ec4d3b8d43" => :high_sierra
    sha256 "6be0f07faacc2785bdcde5a830cca11fcafa1391b5d379f5672a2a9b401e566e" => :sierra
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
