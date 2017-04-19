class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2"
  sha256 "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bb7cb0812d2c408f274d4d66b8d4a0e576de52615837ef177df5aea9e8d376b" => :sierra
    sha256 "be3daf495b46a556db158ad2e1e635c6db7ee27e7d9d77ea65f0bd78ccfddbeb" => :el_capitan
    sha256 "0797e3677954a37cce2ff611cf4c814fc2f9983359de346a7997070902284d76" => :yosemite
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
