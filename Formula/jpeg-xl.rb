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
