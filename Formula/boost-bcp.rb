class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2"
  sha256 "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332"
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
