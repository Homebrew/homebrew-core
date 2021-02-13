class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.2/jpeg-xl-v0.3.2.tar.bz2"
  sha256 "1fd4d187e94e213ce69167700f0f58f62e2eb5d1d5550bc3878838005162ad5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "78de63523001b042c4e20d750cc97237054f6ee120a343b39b47e8a0371e3374"
    sha256 cellar: :any, big_sur:       "05ed7e2271024a9c55bbc204c350f421ed5db5792787db70342edaeeb8bc60fc"
    sha256 cellar: :any, catalina:      "fa1a80b670a836e255534e636de0ffabba5965b793ccde8f3ed053f540e40e68"
    sha256 cellar: :any, mojave:        "0f7b6c24a8cb3cc7fac2b7f4f1e82c5f7669752a62e4b32d056079944cfe1da7"
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
        revision: "a72b33809d98bd1a8fa961953f0f63f454c7f593"
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
