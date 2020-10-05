class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/v2.4.0.tar.gz"
  sha256 "38bce8217afb974e5be070da0b6768bb4fc0e246fa1cee42fecf71c4c6e9ad19"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DBOX2D_BUILD_UNIT_TESTS=OFF
      -DBOX2D_BUILD_TESTBED=OFF
      -DBOX2D_BUILD_EXAMPLES=OFF
    ]

    system "cmake", ".", *args
    system "cmake", "--build", "."
    # Install by cmake when possible: https://github.com/erincatto/box2d/issues/649
    include.install Dir["include/*"]
    lib.install "src/libbox2d.a"
    pkgshare.install "unit-test/hello_world.cpp", "unit-test/doctest.h"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-lbox2d", "-std=c++11",
      pkgshare/"hello_world.cpp", "-o", testpath/"test"
    assert_match "[doctest] Status: SUCCESS!", shell_output("./test")
  end
end
