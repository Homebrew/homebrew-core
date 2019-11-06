class Grt < Formula
  desc "The Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://nickgillian.com/grt/"
  url "https://github.com/nickgillian/grt/archive/v0.2.4.tar.gz"
  sha256 "55bcabe7a58916461dc4341758eff2a45bd5b236c263dfe6e58c176c1a7e1ac4"

  bottle do
    cellar :any
    sha256 "35705ad1d151228e4e8c647cf16fc5b7578b4b777c54e94ebbcc8e19d26bd1f5" => :catalina
    sha256 "830332fffbe52f7eb282eca343977fa27e4ae4978bc9f409df264cba5f37e38c" => :mojave
    sha256 "d5a55b3a6b4ca75d3ef37ba47f43ed033215e0d9b5f5a26f738e484f3e428667" => :high_sierra
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
