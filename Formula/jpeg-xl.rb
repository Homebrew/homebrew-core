class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  license "Apache-2.0"

  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.2/jpeg-xl-v0.2.tar.bz2"
  sha256 "f0933c796f95ee905efa7a677367c0d57678b9587c2e967ea30d72e9405cca72"

  resource "highway" do
    revision = "311c183c9d96e69b123f61eedc21025dd27be000"
    sha256 "51045c5eaf8ef6f1c610c31a22ff7ddf243c98227f3f35871e9a9a4b2caf7d0d"
    url "https://github.com/google/highway/tarball/#{revision}"
  end
  resource "lodepng" do
    revision = "48e5364ef48ec2408f44c727657ac1b6703185f8"
    sha256 "f38176fc103fe1f6d23ba6addd5b14e6a54d546dfaa64663306acfe7b6d912ea"
    url "https://github.com/lvandeve/lodepng/tarball/#{revision}"
  end
  resource "sjpeg" do
    revision = "868ab558fad70fcbe8863ba4e85179eeb81cc840"
    sha256 "2d0306d7273b74e51a61e49483770d83bc27e4dc51efd3ee8e7f4f45996b9f20"
    url "https://github.com/webmproject/sjpeg/tarball/#{revision}"
  end
  resource "skcms" do
    revision = "64374756e03700d649f897dbd98c95e78c30c7da"
    sha256 "f9e8a0f34cd34e216d1736142a5040a8542cf6b1526421d82f33b159cbf910a7"
    url "https://skia.googlesource.com/skcms/+archive/#{revision}.tar.gz"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "clang-format" => :build
  depends_on "coreutils" => :build
  depends_on "parallel" => :build
  depends_on "ninja" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  def install
    mkdir "build" do
      (buildpath/"third_party/highway").install resource("highway")
      (buildpath/"third_party/lodepng").install resource("lodepng")
      (buildpath/"third_party/sjpeg").install resource("sjpeg")
      (buildpath/"third_party/skcms").install resource("skcms")
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system "cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
