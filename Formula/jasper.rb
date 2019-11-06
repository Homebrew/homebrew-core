class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.16.tar.gz"
  sha256 "f1d8b90f231184d99968f361884e2054a1714fdbbd9944ba1ae4ebdcc9bbfdb1"
  revision 1

  bottle do
    sha256 "eb5d0888be36aa8afb0eccc43957eeda99ded64ec5a5531240a4ec99450ba183" => :catalina
    sha256 "ed0856ff9b2429852401e658f4045c9e39cd05fa77b5ea7a6a3c2e21b4d8c460" => :mojave
    sha256 "630b86c544fda0a769815637e37b34e587a6d070b26d642b0d50401f609c744f" => :high_sierra
    sha256 "15ccd9ba448e5de3468d6be07c41106ed77e45d65adbea74a524c042e8791b06" => :sierra
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
