class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
    :tag      => "v1.2.0",
    :revision => "dacb42fe0480e5632a5b6d9ece5cd92558c8e177"

  bottle do
    cellar :any
    sha256 "a5935c1e3f8fe7a403b72ddca24d3a2a9a7bc6e4fc7a6cb2998172dcd1a1745a" => :catalina
    sha256 "202a746514ce9bde4087833a2fe54d624874598ffa7442b05fbfcceb4d680f5e" => :mojave
    sha256 "00d907d20c9c498b267027f873152534a00d2eecba27a2f5ab06e510ed199a61" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -DCMAKE_BUILD_TYPE=Release
    ]

    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args, *cmake_args
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
