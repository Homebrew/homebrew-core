class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_73_0.tar.bz2"
  sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac64b6a5c0a92b976adb030f252f3918ea40323afd1b499882a4f874cdcc67ba" => :catalina
    sha256 "7369c7113fd30285736efe03270a1d1c3a299be137d2f9421fdbe9833686a869" => :mojave
    sha256 "fa1bceff41b7c6cd70f2d5649e4b3a4a6e5c4afed65df14b9d593b7d5e026dfe" => :high_sierra
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
