class Grt < Formula
  desc "The Gesture Recognition Toolkit (GRT) for Real-time machine learning."
  homepage "http://www.nickgillian.com/wiki/pmwiki.php/GRT/GestureRecognitionToolkit"
  url "https://github.com/nickgillian/grt/archive/v0.0.1.tar.gz"
  sha256 "56f90a9ffa8b2bf4e5831d39f9e1912879cf032efa667a5237b57f68800a2dda"

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
