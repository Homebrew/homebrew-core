class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      :revision => "b783805f957c88f97b2b4398e2ace138fbdf831b"
  version "1.0.0"

  bottle do
    cellar :any
    sha256 "1d6f94a87818b90686f8de273d9498c053c96fb0563b4946b9d7334ae4a06446" => :catalina
    sha256 "b0e197272aad07a88f86daf4907ed8799342cd317da7adb105832f2674ac176f" => :mojave
    sha256 "a7328414d688e4d82f97d9fae55268c369db64cafd4c3a75203c616321441c17" => :high_sierra
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
