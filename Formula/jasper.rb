class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.3.tar.gz"
  sha256 "220811235350a17ad134358549fb5163c415e6527f8e37ac3b94980bd8301ccc"

  bottle do
    sha256 "7bc1f6db8ed45196f8dca79af2d380022d7802e5b8fe258272cb07049d400a75" => :sierra
    sha256 "e41312d0f18679baac3dad8bf143dca529e5eb5966aba9d1f6a65fe1dc86da3b" => :el_capitan
    sha256 "5c1cf1616e9896d35bff0ac45140e5a357e556d24061ca2048b91a9af40e96cf" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    ENV.universal_binary if build.universal?

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
