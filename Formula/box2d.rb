class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/v2.4.1.tar.gz"
  sha256 "d6b4650ff897ee1ead27cf77a5933ea197cbeef6705638dd181adc2e816b23c2"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "ce38e11785a57c7cd416fd4cb6a9cd2567363e1f1bc4938d010b13e0b2eefc34"
    sha256 cellar: :any_skip_relocation, big_sur:      "bec33552a3bf184fd75f6adbb193b15595c7729dd7f457c833b7826c6253c28d"
    sha256 cellar: :any_skip_relocation, catalina:     "5c6508a2d661409273a28ac5f0495d7d7c506b5d1bc7ceeb9ab90298db225178"
    sha256 cellar: :any_skip_relocation, mojave:       "51709abf7cf22ce487b7fb543c2760add5f6935459b00163567448f47ab6d86c"
    sha256 cellar: :any_skip_relocation, high_sierra:  "0312b876dd91ae896fc127fa6afe21736b7dd1d55569389a6cfc20af90f83cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a36a72d0a0d92cc4c981ad6950fcaa106ad23c273e573dd82bdc971379e0ea70"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DBOX2D_BUILD_UNIT_TESTS=OFF
      -DBOX2D_BUILD_TESTBED=OFF
      -DBOX2D_BUILD_EXAMPLES=OFF
    ]

    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
    pkgshare.install "unit-test/hello_world.cpp", "unit-test/doctest.h"
  end

  test do
    system ENV.cxx, pkgshare/"hello_world.cpp", "-L#{lib}", "-lbox2d",
      "-std=c++11", "-o", testpath/"test"
    assert_match "[doctest] Status: SUCCESS!", shell_output("./test")
  end
end
