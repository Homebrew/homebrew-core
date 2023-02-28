class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/v2.4.1.tar.gz"
  sha256 "d6b4650ff897ee1ead27cf77a5933ea197cbeef6705638dd181adc2e816b23c2"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f944702e28ec7033d7c7da6daee29d1b6153b737fe515754adf898a701b3cfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "360bc1f63ba8cb1f6c97316c00da7ae547bcdb0be6c18f1dd441a338dbed67f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f7821254f00753fc07028c94c0c08e42b3e05dbee86119887c43d446b786270"
    sha256 cellar: :any_skip_relocation, ventura:        "4f5a62c8c3cc7c77494381117f15ccd74c6d3a7569bb4e4ade8840bd489181dd"
    sha256 cellar: :any_skip_relocation, monterey:       "ce38e11785a57c7cd416fd4cb6a9cd2567363e1f1bc4938d010b13e0b2eefc34"
    sha256 cellar: :any_skip_relocation, big_sur:        "bec33552a3bf184fd75f6adbb193b15595c7729dd7f457c833b7826c6253c28d"
    sha256 cellar: :any_skip_relocation, catalina:       "5c6508a2d661409273a28ac5f0495d7d7c506b5d1bc7ceeb9ab90298db225178"
    sha256 cellar: :any_skip_relocation, mojave:         "51709abf7cf22ce487b7fb543c2760add5f6935459b00163567448f47ab6d86c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0312b876dd91ae896fc127fa6afe21736b7dd1d55569389a6cfc20af90f83cd6"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :test

  def install
    args = %w[
      -DBOX2D_BUILD_UNIT_TESTS=OFF
      -DBOX2D_BUILD_TESTBED=OFF
      -DBOX2D_BUILD_EXAMPLES=OFF
    ]

    system "cmake", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
    pkgshare.install "unit-test/hello_world.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"hello_world.cpp",
                    "-I#{Formula["doctest"].opt_include}/doctest",
                    "-L#{lib}", "-lbox2d",
                    "-std=c++11", "-o", testpath/"test"
    assert_match "[doctest] Status: SUCCESS!", shell_output("./test")
  end
end
