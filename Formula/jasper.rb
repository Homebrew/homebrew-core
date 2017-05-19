class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.13.tar.gz"
  sha256 "b50413b41bfc82ae419298b41eadcde1aa31f362fb9dc2ac089e5cbc19f60c24"

  bottle do
    sha256 "386f26d020cbe06b80066c34cf6a4f679562b93211ef74d244ca119604af8d13" => :sierra
    sha256 "be03c9d8ef6f4a3dd056ce7358c0ebbdd366542e9c00639c223ea0d5bb941ada" => :el_capitan
    sha256 "9390f990b9bd0e4605c2c012c80e8ec40ac2f539cd79814fcf276a12bbe32b4a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
