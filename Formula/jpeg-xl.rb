class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.2/jpeg-xl-v0.2.tar.bz2"
  sha256 "f0933c796f95ee905efa7a677367c0d57678b9587c2e967ea30d72e9405cca72"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "e8a6f194a35e81831136c4358786fc2842f9bc57479244f49740e94d70b19635" => :big_sur
    sha256 "490127aa154b9da56a38133488fd19da54eba9d41fbbdb9bd06d54a0d3652d1e" => :arm64_big_sur
    sha256 "00953f8445b3243b800e178ae420eb6f032814cf77aac7e62f6625190eb01315" => :catalina
    sha256 "f3b0878512490e4ec342c6b21c532c13a3b67546b2f6f428f11b55796bffe1b3" => :mojave
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
        revision: "311c183c9d96e69b123f61eedc21025dd27be000"
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
