class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      :revision => "b783805f957c88f97b2b4398e2ace138fbdf831b"
  version "1.0.0"

  bottle do
    cellar :any
    sha256 "69ffc1316e0b4fce904bc5acf5e23fa39de324c5701dfd0cf0424950c62550fc" => :catalina
    sha256 "6c6bf1cc7f0a9f3409426830c6fb4d7cbf8647335874f1ceccf50c5997687e7e" => :mojave
    sha256 "46d0fbaab6f4a01e31ac8ea751128fbf6b68ce96133de6acf5ae02e18d33554a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "../cmake", "-Donnxruntime_BUILD_SHARED_LIB=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <onnxruntime/core/session/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lonnxruntime",
           testpath/"test.c", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
