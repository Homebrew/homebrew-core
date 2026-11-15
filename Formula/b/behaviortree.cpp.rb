class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.11.1.tar.gz"
  sha256 "f590d4b0f87f027e603235c7c8b056b9fe8ec495b1d067e94d86ebf160177aba"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "725bfdbf10d7bfa413436e796612e6e68e2c3532f21cfa4adf15a4dda9cb041e"
    sha256 cellar: :any, arm64_tahoe:       "e0a82ad8859296d6326be624a06bff825a1918d706d711d497d271e001e37a66"
    sha256 cellar: :any, arm64_sequoia:     "08b3eada795f6a95d71fca1c44462854b175f9b65637f2086aa16978c4caa7df"
    sha256 cellar: :any, arm64_linux:       "75d67468eb30f10fde274a52dd6137e16f069dd1a2146561e71b2bdbaeeef583"
    sha256 cellar: :any, x86_64_linux:      "3d7cde43c1d92f53c8b9e38483d6f4a96abadbc1617759bfe8aa80dfd6043d29"
  end

  depends_on "cmake" => :build
  depends_on "cppzmq"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBTCPP_UNIT_TESTS=OFF
      -DBTCPP_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
