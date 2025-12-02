class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.8.2.tar.gz"
  sha256 "fe682bc2a3430378611d5d520970333fcd57874eb726fce59b5b274b947b0ba7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67342d96ba2d203b132223ce51ba81bd0fc1d498d53957ba5bded071c384da11"
    sha256 cellar: :any,                 arm64_sequoia: "bae8f0836a5e497e927de88478139970d78595b03447c3eddd38ef7891bf9a8e"
    sha256 cellar: :any,                 arm64_sonoma:  "0a0e9cef835e063ab997f313050f4bc9d5d66f1c795636fb3de7206bc673ae3d"
    sha256 cellar: :any,                 sonoma:        "aa5867b56b1270c40d11616a038e26cc5a319f6199fbe810a65609af8dde2b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163b27a6eba8374810b3d612608a323d8d9e30c4bb0277aba2825be0864717ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2dbdf83f6a1582a640313f179a6229bf1e22389e84f208ed513a8aef865ea99"
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
