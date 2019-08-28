class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      :revision => "14eae293bf84956f371bfac50628e15b73751940"
  version "0.5.0"

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    system "#{Formula["python"].opt_bin}/python3", "tools/ci_build/build.py",
           "--build_dir", "build/Linux", "--config", "Release",
           "--build_shared_lib", "--skip_submodule_sync"

    lib.install Dir["build/Linux/Release/*.dylib"]
    include.install "include/onnxruntime/core/session/onnxruntime_c_api.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetVersionString());
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lonnxruntime",
           testpath/"test.c", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
