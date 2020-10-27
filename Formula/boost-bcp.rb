class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_74_0.tar.bz2"
  sha256 "83bfc1507731a0906e387fc28b7ef5417d591429e51e788417fe9ff025e116b1"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38f3f9e20897c805ea1faac0c9768d17fff8f6dc0704bd981ebd5a69e9281d04" => :catalina
    sha256 "a428123afc2e1048d07d8c080d8f8a5521bb30f7dc73dc15210e2d1ad8154796" => :mojave
    sha256 "b2f4c2fca43163d3d3cc3bccb785446ccd56c664c951eb92712fca226765b6ba" => :high_sierra
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
