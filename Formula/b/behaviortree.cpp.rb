class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.9.1.tar.gz"
  sha256 "509f508aa8ce38ec8c54b91e94f2049c4b00905474d38e503057f0c2a3054e31"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "14b5dba31c77ff588d8c63ebb50482aff916b398eae2492e50962f61ce9d538c"
    sha256 cellar: :any, arm64_sequoia: "3f2892d1153412baae715de01066ba44bd491e526994713d6131dc551ccd1c21"
    sha256 cellar: :any, arm64_sonoma:  "1be0656b86065fdd5398dcf0b7f1b8d758b5d3be60aba8ae8a96bc8d86177546"
    sha256 cellar: :any, sonoma:        "e883cdd1380a2ecc29986d7128ac3dbeca9b162a0a5e0ce20d5ab6e1545afa54"
    sha256 cellar: :any, arm64_linux:   "d67126041cff83c3903d54eefef185355a68f669ace95f2647fde204d149d56b"
    sha256 cellar: :any, x86_64_linux:  "594ed6ff1c96ff75bbe9e0df495eefacefed0cba036f99309cf17910a42d92d1"
  end

  depends_on "cmake" => :build
  depends_on "cppzmq"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  # Apple libc++ has no floating-point std::from_chars; fall back to std::stod.
  # PR ref: https://github.com/BehaviorTree/BehaviorTree.CPP/pull/1160
  patch do
    url "https://github.com/BehaviorTree/BehaviorTree.CPP/commit/865e9a47eca0f8a1b10c636d90f4b00eebe360af.patch?full_index=1"
    sha256 "4ab0e1d247a89a3d29c8eb3a6d1423d4eaedb5d07f26cf4f211d8258e6650d2c"
  end

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
