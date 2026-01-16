class Grt < Formula
  desc "Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://nickgillian.com/grt/"
  url "https://github.com/nickgillian/grt/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "55bcabe7a58916461dc4341758eff2a45bd5b236c263dfe6e58c176c1a7e1ac4"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c6059dfbaae19edd07d9b9c4df53dc8797cfe6d918ce9cfec5628bfefc6ca3f7"
    sha256 cellar: :any,                 arm64_sequoia:  "074ba306d1024617ace8a0f056a9c55cf8cdb53ede10471eb77eeab5435f6e6d"
    sha256 cellar: :any,                 arm64_sonoma:   "4fb256ad0e810c361d218210ba816f27e7f36d0b03547dba8a503d804c7928d3"
    sha256 cellar: :any,                 arm64_ventura:  "b6aa8b0ecb30a18b3a1ddeb21a08f9b7aa12226bea2174a5bfce165e1e56e477"
    sha256 cellar: :any,                 arm64_monterey: "a875908262d55401a19c3f03fc58c6c44aaa380a3f28c7d0c7686bf3226e33b5"
    sha256 cellar: :any,                 arm64_big_sur:  "e7fb295223786373ecfb9a7bfd323b234a2c9034f9fc2f4705ff1209be93dcfb"
    sha256 cellar: :any,                 sonoma:         "6cbbeba38afd1267c3db39c759771e7a58d28a82eeaac6c3e90e0bba92185f02"
    sha256 cellar: :any,                 ventura:        "bc61d78a6e3788cfbd018970acdcb4d60bcf7b66da889c5dd908dcda2e701d1a"
    sha256 cellar: :any,                 monterey:       "91ca908ff9c97a1cc86b8899d97e7f4d97d1d0a0dcbf959bd8f6d2a44ed04ce3"
    sha256 cellar: :any,                 big_sur:        "1d4777cee44f7b99247cc34cda090ca59e720a14f20b9d2336d21e06bc309d4a"
    sha256 cellar: :any,                 catalina:       "35705ad1d151228e4e8c647cf16fc5b7578b4b777c54e94ebbcc8e19d26bd1f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e0eeec38e25fa39e7e63c6e2a3a740e088522c789c77ea3361b5d6d7fd30e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9faf092937716c46062df1823e3af440e986eba4d3de6a965fbedd619b4e43e"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", "build", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
