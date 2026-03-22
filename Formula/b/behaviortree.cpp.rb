class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.9.0.tar.gz"
  sha256 "74a22cf46d7cd423d7065616528cfd68bcd925b3fc2b819a99413cdd3334c02a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "114719f633b5ca2f9633a1e216818ce5e5be32adda4ff470dab3240a7ac5f4c4"
    sha256 cellar: :any,                 arm64_sequoia: "03a0a0c273a511c2d7ef3ed76c3871c9ca2474354734e260d61af36c212efe61"
    sha256 cellar: :any,                 arm64_sonoma:  "0996134f6c16aa796a48e444e757ac491d9e959cba7ce70ff91731af8af0dc26"
    sha256 cellar: :any,                 sonoma:        "1928e8dd45bc8e90a760f7118929ac6875ffdf4625dc6407efbeabbe04a45c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a23cbd22d0f61cc11c44630a9fc28487d75bb721750bd5ee721f33b9c1edc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5e85e34d2e581413dbfc25823c7c1579b58c2ffc1525ec0b0b8afa1da666b3"
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
