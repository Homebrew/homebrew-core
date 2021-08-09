class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.5/jpeg-xl-v0.5.tar.bz2"
  sha256 "43ae213b9ff28f672beb4f50dbee0834be2afe0015a62bf525d35ee2e7e89d6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "96c7e3fb74af26795318c88c155f39d9a83dbebcbc7f1a60484b6a5e08271ddf"
    sha256 cellar: :any, big_sur:       "490ff94de3ad3f6a2392c862f4719dc65209a96120b788540a4a784e283b1f36"
    sha256 cellar: :any, catalina:      "1c9760ea8ee1c5040000768bb6aa58a54f3d9357dcc9553d1f2bd91334b4d671"
    sha256 cellar: :any, mojave:        "7801c452701a99cfb8fb8b78192c345a01070492285acabd6746cc40314765e0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://gitlab.com/wg1/jpeg-xl/-/blob/v#{version}/deps.sh
  resource "highway" do
    url "https://github.com/google/highway.git",
        revision: "e2397743fe092df68b760d358253773699a16c93"
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
