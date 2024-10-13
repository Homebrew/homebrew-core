class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "85b9b104d256c985e6e244b4227d447897fac429071cc114e5cc819dae848852"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fb381cacb973bb83acea61d445f4481e2986077925c462a72f0e42a56204761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1004520deaab7266d3e2a3376c88c6a5ecbb0a5661fa0f758f9019a3fcaa4afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "690e7314d93f6ce71411117355a7bbb20e80af3b6ee5e8ec3dc8a0206f8f8185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348e4835ab1d24fa9e5235881f7c2c1093aff7ed608830bdf505f89194190e75"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c0f27f23c15f669953359c166972a465d9dca11045281050ed3e3bbcb12122"
    sha256 cellar: :any_skip_relocation, ventura:        "f0aebdc3f3d506c0b2018588cc9cefc6ee66b8d002218f617c16e9011d126656"
    sha256 cellar: :any_skip_relocation, monterey:       "abc781043d1cc1b62bffcba6593071884bc624451beae3552324b59333449b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcc479cc9727d27fc40725c5aed9f937a3a5aa06682a6b9affd4a0e7f9d3e74"
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
