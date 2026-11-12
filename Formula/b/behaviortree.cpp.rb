class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.11.1.tar.gz"
  sha256 "f590d4b0f87f027e603235c7c8b056b9fe8ec495b1d067e94d86ebf160177aba"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "34a03e9d15fa1f63c9011301978a77a6ddc21035e71866948e0c0858617d0af8"
    sha256 cellar: :any, arm64_tahoe:       "fbe058839c8b8a3d9e3134c244043233aa6653ff4f4152a399d8bb768a6b0263"
    sha256 cellar: :any, arm64_sequoia:     "4b9ae44f3c00b0ec98bf850527cb3b8dc5098f907a8d442e90c2b00b920c9cf3"
    sha256 cellar: :any, arm64_linux:       "184c048012307335e785eb4caa82e3448e1bc3e60827f8e4e51fd34888ee3121"
    sha256 cellar: :any, x86_64_linux:      "07d42b8a0b251f8af7fe0f10b2890bc3e34d72083e3917079fbd80c674cd5c06"
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
