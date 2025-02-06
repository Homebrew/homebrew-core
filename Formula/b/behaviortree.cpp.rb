class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.6.2.tar.gz"
  sha256 "b0e7e53b27feae894e2df3f3faadfdd49f2108ebccfb1bd7cc0d405ffc56cecd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76735a4aaa8407db888e5dcda8cdd615c867d60d22e7571a09815189c6638529"
    sha256 cellar: :any,                 arm64_sonoma:  "1d302e8019808583145e3cd797615fa030821e6019530c4438cf88f6d622172a"
    sha256 cellar: :any,                 arm64_ventura: "d66a7461ae47f2c5bf0e8fec136178870098cb66ea06a4f2ce271da3317fbb6b"
    sha256 cellar: :any,                 sonoma:        "2305e0df7acf9f12494b0f8df56f993cb571256c039217dff05fca9d1f672225"
    sha256 cellar: :any,                 ventura:       "a43a30fc1138ca2e6553c1d29ebf7936bd1f61569595b4dd1a58f1e21499c0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca79c98d692d391afd368f2da3fb03e561686afe91312f664aa94ebdabb2e1a"
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
