class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.7.3.tar.gz"
  sha256 "17dc83b55b087fe6a489c0a7d16c9b02289d1e68c1298279667a9ab07f705b8b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18c752c1594f0d59134c4f6c7db2816e4ec1dab66ca0a9ed1838b18bbc5fd63a"
    sha256 cellar: :any,                 arm64_sequoia: "545aec96e8775878a29703c02206cf910a404b58dbcd51c15b43bfa74b59c0aa"
    sha256 cellar: :any,                 arm64_sonoma:  "6664909f59c9bc6ed7b574676636ad787420cd46ef030fab0335988d0b2c321d"
    sha256 cellar: :any,                 sonoma:        "c904edea805dd1c7af2d7c98a124390c8fcf53f6051a66d8cdae4f9e3cb9ca1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85c73e1127c04a8eb6049cdbbc99ea5c5475ae9c48c37386cf16243678f3a224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577bb84679f48f13526d11ba2b3f8752df759cb34cd333f8dc765bee291985ca"
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
