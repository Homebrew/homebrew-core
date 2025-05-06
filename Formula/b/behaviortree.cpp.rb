class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.7.0.tar.gz"
  sha256 "ee71a20daa245b4a8eb27c8352b0cb144831c456bdac4ed894694a1f78e407da"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52f7cfadacdbc883fe8ff31d63d35999ac3760de50c6b06aec8bbc42609d6065"
    sha256 cellar: :any,                 arm64_sonoma:  "945f0fd0d38d560bcaf846fb4869bf9a12d3be69914b0a289df0383253a8cde0"
    sha256 cellar: :any,                 arm64_ventura: "80638476aea8b680279e4182187de3287bced1943a3ecb73ac57412467c7720e"
    sha256 cellar: :any,                 sonoma:        "b94d472de6436dc82acfcd7c238030bbd36c150840d814261c83ef072999fe77"
    sha256 cellar: :any,                 ventura:       "bb712eac3ef203453fc1ecff902ffd63a7810a8cd58a889a1f23015dfdac50bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f20fe6e1b5cdea2d4ef0ebf26d1c509d2e14a72c11486b822877142b32031c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a60313596f47e4a444159c5eff129eb1ceb8881a2441d46df7c2ca85cc8b83d"
  end

  depends_on "cmake" => :build
  depends_on "cppzmq"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBTCPP_UNIT_TESTS=OFF",
                    "-DBTCPP_EXAMPLES=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/t03_generic_ports.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lbehaviortree_cpp", "-o", "test"
    assert_match "Target positions: [ -1.0, 3.0 ]", shell_output("./test")
  end
end
