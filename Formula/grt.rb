class Grt < Formula
  desc "The Gesture Recognition Toolkit (GRT) for Real-time machine learning."
  homepage "http://www.nickgillian.com/wiki/"
  url "https://github.com/nickgillian/grt/archive/v0.0.1.tar.gz"
  sha256 "56f90a9ffa8b2bf4e5831d39f9e1912879cf032efa667a5237b57f68800a2dda"

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build"
    cd "build"
    system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", ".."
    system "make", "-j#{Hardware::CPU.cores}"
    system "make", "install"
  end
  test do
    # A simple test to see if we have GRT setup properly (only compilation).
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
