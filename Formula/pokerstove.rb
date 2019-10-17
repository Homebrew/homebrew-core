class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"

  bottle do
    cellar :any
    sha256 "db03f71aebe4fd46061765ae3659629ee42a5166f2dbb8b225f53b5baf7fbe62" => :catalina
    sha256 "60f469d6ec2b39eac5d801c7968f56b21ddd0464ebc074964f6dacb4cd151b74" => :mojave
    sha256 "49b7d8bcd4c54b42dbd311f94dcfb71ff04d3a1e273ecda213baaa562ad9b02b" => :high_sierra
    sha256 "c78b16c6cfd9981df7ba66dd367f3b25181350d317e0ec00704a3b837383a8e8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install Dir["bin/*"]
    end
  end

  test do
    system bin/"peval_tests"
  end
end
