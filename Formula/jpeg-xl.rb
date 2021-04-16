class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.7/jpeg-xl-v0.3.7.tar.bz2"
  sha256 "32548f17c2a596e9963aa09934710f96dca6f78ec2337d7936dada89a6090b56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f55a2b63bdfce332ea36992cd396c1b39509b9d91d82dd37dd7d634190917ea1"
    sha256 cellar: :any, big_sur:       "2aa6ad9199ad94b97ba429131047c184a967c8dfbd716fd838ffbe9cde271069"
    sha256 cellar: :any, catalina:      "1c7045daa7a1ecd04cd806dba786787b289474abaaad203b1f6e12a4a7a51d09"
    sha256 cellar: :any, mojave:        "2d22106294d198216a8cf4ba0737cd125e4434d3790968f9f9b44825d5f0f7f1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://gitlab.com/wg1/jpeg-xl/-/blob/v#{version}/deps.sh
  resource "highway" do
    url "https://github.com/google/highway.git",
        revision: "946a1b40233438a1b0363598a6deaa1628a01003"
  end

  resource "lodepng" do
    url "https://github.com/lvandeve/lodepng.git",
        revision: "48e5364ef48ec2408f44c727657ac1b6703185f8"
  end

  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  resource "skcms" do
    url "https://skia.googlesource.com/skcms.git",
        revision: "64374756e03700d649f897dbd98c95e78c30c7da"
  end

  def install
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system "#{bin}/cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
