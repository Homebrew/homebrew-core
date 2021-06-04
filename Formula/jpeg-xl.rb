class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.7/jpeg-xl-v0.3.7.tar.bz2"
  sha256 "32548f17c2a596e9963aa09934710f96dca6f78ec2337d7936dada89a6090b56"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e855720e77098e6cf1ada7dd53561e73f426d7b241512c209ef8b21b915cd3b1"
    sha256 cellar: :any, big_sur:       "0abccbb80acb60e345bc1f338bb7647bb6fb946529343104c887b4dc02b685fb"
    sha256 cellar: :any, catalina:      "432600f118932b15359629c9a94f5a8e017d9985ae888af21f5f605b2f886dbd"
    sha256 cellar: :any, mojave:        "d2045261bd46e2deaf3f3c460cac89f3b1810da54379df93a5be1e4f82399244"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr@2"
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
