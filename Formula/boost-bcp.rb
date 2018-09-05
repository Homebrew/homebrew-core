class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2"
  sha256 "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88914eda8199507b76c987793890cad9a9266e9fc3ca58178f26ddc2a4acb86a" => :mojave
    sha256 "e474233c8dfca682f52738f2739684d792d7b5b3a85e81f2c434299924738746" => :high_sierra
    sha256 "c912fa881ea33709f02bb8d6ac4ec8a89e882eaea7a8c4b78dd0632039a65feb" => :sierra
    sha256 "8fb1db8e4887872abd0ce2d9197f5ee82f95470b08e1efc3fb486af7ac8b1bea" => :el_capitan
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
