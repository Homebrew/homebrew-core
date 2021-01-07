class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.2/jpeg-xl-v0.2.tar.bz2"
  sha256 "f0933c796f95ee905efa7a677367c0d57678b9587c2e967ea30d72e9405cca72"
  license "Apache-2.0"

  # The build dependencies are documented on the jpeg-xl osx-build page
  # https://gitlab.com/wg1/jpeg-xl/-/blob/master/README.OSX.md
  depends_on "clang-format" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "ninja" => :build
  depends_on "parallel" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://gitlab.com/wg1/jpeg-xl/-/blob/master/deps.sh
  resource "highway" do
    revision = "311c183c9d96e69b123f61eedc21025dd27be000"
    sha256 "40a4aaafbda61dd93803d8c830971f77d1b0b33c648ed29b5032f8798d293f21"
    url "https://github.com/google/highway/archive/#{revision}.tar.gz"
  end
  resource "lodepng" do
    revision = "48e5364ef48ec2408f44c727657ac1b6703185f8"
    sha256 "c47c48c77a205f1af484b7b5a847290af65de3ea6f15817aa27c5ec7cc5208fd"
    url "https://github.com/lvandeve/lodepng/archive/#{revision}.tar.gz"
  end
  resource "sjpeg" do
    revision = "868ab558fad70fcbe8863ba4e85179eeb81cc840"
    sha256 "72279cd6d4089b62a49cb127353bf875cb35844eda42d90901dd32f08992060e"
    url "https://github.com/webmproject/sjpeg/archive/#{revision}.tar.gz"
  end
  resource "skcms" do
    revision = "64374756e03700d649f897dbd98c95e78c30c7da"
    sha256 "f9e8a0f34cd34e216d1736142a5040a8542cf6b1526421d82f33b159cbf910a7"
    url "https://skia.googlesource.com/skcms/+archive/#{revision}.tar.gz"
  end

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
