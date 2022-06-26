class Grt < Formula
  desc "Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://nickgillian.com/grt/"
  url "https://github.com/nickgillian/grt/archive/v0.2.4.tar.gz"
  sha256 "55bcabe7a58916461dc4341758eff2a45bd5b236c263dfe6e58c176c1a7e1ac4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a875908262d55401a19c3f03fc58c6c44aaa380a3f28c7d0c7686bf3226e33b5"
    sha256 cellar: :any,                 arm64_big_sur:  "e7fb295223786373ecfb9a7bfd323b234a2c9034f9fc2f4705ff1209be93dcfb"
    sha256 cellar: :any,                 monterey:       "91ca908ff9c97a1cc86b8899d97e7f4d97d1d0a0dcbf959bd8f6d2a44ed04ce3"
    sha256 cellar: :any,                 big_sur:        "1d4777cee44f7b99247cc34cda090ca59e720a14f20b9d2336d21e06bc309d4a"
    sha256 cellar: :any,                 catalina:       "35705ad1d151228e4e8c647cf16fc5b7578b4b777c54e94ebbcc8e19d26bd1f5"
    sha256 cellar: :any,                 mojave:         "830332fffbe52f7eb282eca343977fa27e4ae4978bc9f409df264cba5f37e38c"
    sha256 cellar: :any,                 high_sierra:    "d5a55b3a6b4ca75d3ef37ba47f43ed033215e0d9b5f5a26f738e484f3e428667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9faf092937716c46062df1823e3af440e986eba4d3de6a965fbedd619b4e43e"
  end

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
