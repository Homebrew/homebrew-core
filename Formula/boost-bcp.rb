class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.bz2"
  sha256 "ea26712742e2fb079c2a566a31f3266973b76e38222b9f88b387e3c8b2f9902c"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a6d2fae665c4913202f7f12672f6950b2a0c6c11e027d26be817b16804cd771" => :sierra
    sha256 "45199e3f4130b44c7ebb87abc08343ead5b2433984bc31541e5c76cfe30639d1" => :el_capitan
    sha256 "2c5b4c25630f0ee761fe17cb84811f25fc1c2c4aeae6189d7b61412f43c93439" => :yosemite
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
