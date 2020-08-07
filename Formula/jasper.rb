class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.19.tar.gz"
  sha256 "b9d16162a088617ada36450f2374d72165377cb64b33ed197c200bcfb73ec76c"
  license "JasPer-2.0"

  bottle do
    sha256 "6e08d9c308ba24cc512801f4f9ae9b06353ab3d10139c3679410f0e038e217b1" => :catalina
    sha256 "93402fee0d364ee6538c48af922705a47ac751b9929d58d1f2961a54963c952d" => :mojave
    sha256 "27d5d3e6ef809625d76755c043ad226f28d85d8dcf65c3449edbdfbfe96d9e62" => :high_sierra
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
      system "make", "clean"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", "-DJAS_ENABLE_SHARED=OFF", *std_cmake_args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
