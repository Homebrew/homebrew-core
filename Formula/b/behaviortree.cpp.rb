class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.10.0.tar.gz"
  sha256 "c758fdedb3666f7ca4c9998a4c0b243251e0a5fb5d03c99e2ee63d615af7a71d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9cab59f5d9d6738c492aa63f6c27892805dd6b2d36d882dee2b7023d0cb09088"
    sha256 cellar: :any, arm64_sequoia: "2818f89a6312b0ca18797e437b42ad3de3fb4285d513228aaff120e5e7343959"
    sha256 cellar: :any, arm64_sonoma:  "12874a455228ef604d858a26bfc47214282bde9f5dbbc9df80934cdf07e71795"
    sha256 cellar: :any, sonoma:        "690672df523641c56960df0ab602becd78384071a1b6f2460bce9851023ce96d"
    sha256 cellar: :any, arm64_linux:   "89c307daaa7df946e0232ca672cc6b58b4c61847e98eae8516401f7d07cd26ae"
    sha256 cellar: :any, x86_64_linux:  "7bdee9018bc6a23069b2b9876149c22fa500abc145fbaadd5b845310f8123314"
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
