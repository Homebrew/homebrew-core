class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.6/jpeg-xl-v0.3.6.tar.bz2"
  sha256 "6570cd8b4ab4d4b1b928ff2f86de246d151507c679c98257179cd54037ffc42c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b10b1532d225476cd60335355b566d8f9a882b86c9054cc346ff8dc7538a395c"
    sha256 cellar: :any, big_sur:       "2e24591110fb8b9018d591b1265b930a11feb5029b727a9a8bdadf38bc5042fc"
    sha256 cellar: :any, catalina:      "5e51af4f608b8c38d0b59cda93cf8415b9684d1165a9f1aadc95b9f48ffff095"
    sha256 cellar: :any, mojave:        "063e06aa630be9a7d03cfcb8c74a02192841c43449c6cc01e6e9c20126a620f8"
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
