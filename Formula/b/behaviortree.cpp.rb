class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.7.2.tar.gz"
  sha256 "fa52bfd1f23a65ecf7da887b565213441a3628dab85179329d4731a6d273ebd5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "287a827d7ee1eaf4183d1b96b731ac76818742a3fa3fd25c0bf730eff06fe2d1"
    sha256 cellar: :any,                 arm64_sonoma:  "1e8bc3ce758fa6c41a04df7103cd9af35f6282f6bbd01cd21ccb360a1a07d678"
    sha256 cellar: :any,                 arm64_ventura: "8130722b4e1f778150a591fe5683c42b35c02c728d3f6841902bc381a1f59ab5"
    sha256 cellar: :any,                 sonoma:        "d13d59ee51d12603e80c1e92e0f439c1777dfdb72f48b2539d075d2dcf42a736"
    sha256 cellar: :any,                 ventura:       "5d8380fa532c1116067e3df6dcfe453f4fd11f37d340bc4ff43d15ca9199b016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f411456a62a19fb19c7b09be80e13b6938fd4a2970778b772dbe9b555878c141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8acd7de66935419328ad2804bacdf2137041cefe500fd3dbd6200067542c260"
  end

  depends_on "cmake" => :build
  depends_on "cppzmq"
  depends_on "zeromq"

  uses_from_macos "sqlite"

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
