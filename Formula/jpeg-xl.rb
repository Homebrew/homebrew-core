class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl.git",
    tag:      "v0.2",
    revision: "31c71b0f61123a40789b0b8f54feb70e5995420e"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"

  fails_with :clang

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DBUILD_TESTING=OFF", ".."
      system "cmake", "--build", "."
    end
    bin.install "build/tools/benchmark_xl" => "benchmark_xl"
    bin.install "build/tools/cjxl" => "cjxl"
    bin.install "build/tools/djxl" => "djxl"
  end

  test do
    # system "false"
    system "cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
