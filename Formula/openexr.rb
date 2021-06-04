class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.0.4.tar.gz"
  sha256 "64daae95d406fe3f59ee11ad8586d03fe7df2552b9630eac1a4f9152b8015fb9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a12edd2584cfb3bb7e2de2bfd11654e6b12db035f4090eaacb29d87599faf92d"
    sha256 cellar: :any, big_sur:       "cc545cdc67223b489c2058288494ebae300fe244aec1c8ac7410c40b74003183"
    sha256 cellar: :any, catalina:      "afbf9bd6664d6b43d3bcc376cab03bade505bcb823f1e663b8fd23c2578f2709"
    sha256 cellar: :any, mojave:        "0f18fbc0d4951ecd56ec9ce8f55d99c905ead8eb6402803aeb7db7d6d7f340ba"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
