class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.8.4.tar.gz"
  sha256 "361bd8051f2dc1a07d75583bc096e02a5d00d9aa0e3bc2ee9233d63dcea9980f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c9edea062d42c2294c0f5fd6a4a79b10c9d9eb6e31069134dbde0dba043ca2e"
    sha256 cellar: :any,                 arm64_sequoia: "7f7e33d40ab955d7eecdbf9ea8e678ce56abfc3a9594d4cab31e4e57c876e2da"
    sha256 cellar: :any,                 arm64_sonoma:  "7d7cabf84152ad40b6e86fdd9b4bab8dc97eb9860330f519facff31a7deed7ba"
    sha256 cellar: :any,                 sonoma:        "0c0600400eda4336698f30f665b19b5fbc660d6907740076952af248ec65827f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a0a413e8d17f2cd3a91f31043a29af63f528cade8a57418fadc2f1d0fd54f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a17c1c0eaae75be7ceadcd86840777dc12403d50846580a91c003b7a6585d2f"
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
