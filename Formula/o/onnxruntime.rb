class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.24.2",
      revision: "058787ceead760166e3c50a0a4cba8a833a6f53f"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34d3d30fa55d8e94477694ad6ad06fa3c70fbd9ecb51147f28ab673855ba5a0c"
    sha256 cellar: :any,                 arm64_sequoia: "6a7e8a3a39d75331d0aadda9fc1d62d9c7e79134b68536bcdab04e06f9ff57d8"
    sha256 cellar: :any,                 arm64_sonoma:  "05ab7de043662455bf8ef58c73ad37f930e90095cb5e4d19af0c5e5c5b9218f5"
    sha256 cellar: :any,                 sonoma:        "d997b48ba4bf3e16d2b4bebd699a42d0c1725ac1a3277b090f2f89ea61261de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "161d33b78882d35be3f2a2e2c86b9c8f4620d87e5dc70742a332a207d6e80e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb0faaa63046b5de2c2b3021a54f0b8f63cc5430d81f69e2acf781ff23fba88"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "eigen" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.14" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/403d652dca4c1046e8145950b1c0997a9f748b57.tar.gz"
    version "403d652dca4c1046e8145950b1c0997a9f748b57"
    sha256 "c33bcad94ccbdd4966cc21291f0dcacd40d1dd04eb4c2a6ef1c8da669c01e024"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^pytorch_cpuinfo;.*/(\h+)\.zip}i)
    end
  end

  # Apply Fedora's workaround[^1] to allow `onnxruntime` to use `onnx` built without
  # ONNX_DISABLE_STATIC_REGISTRATION[^2]. We can't use this option as it will
  # break functionality for any dependents/users expecting the default behavior.
  # The main alternative is to build a bundled copy of `onnx`.
  #
  # [^1]: https://src.fedoraproject.org/rpms/onnxruntime/blob/rawhide/f/0013-onnx-onnxruntime-fix.patch
  # [^2]: https://github.com/microsoft/onnxruntime/issues/8556#issuecomment-1006091632
  patch :DATA

  def install
    python3 = which("python3.14")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_MP11=#{Formula["boost"].opt_prefix}
      -DPython_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf"].opt_bin}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=OFF
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Modified copy of upstream's testcase at
    # https://github.com/microsoft/onnxruntime/blob/main/onnxruntime/test/wasm/test_inference.cc
    (testpath/"test.cc").write <<~CPP
      // Copyright (c) Microsoft Corporation. All rights reserved.
      // Licensed under the MIT License.

      #include <cassert>
      #include <iostream>
      #include <onnxruntime/onnxruntime_cxx_api.h>

      int main(void) {
        Ort::Env ort_env;
        Ort::Session session{ort_env, "mul_1.onnx", Ort::SessionOptions{nullptr}};
        auto memory_info = Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU);

        std::array<float, 6> input_data{1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f};
        std::array<int64_t, 2> input_shape{3, 2};
        Ort::Value input_tensor = Ort::Value::CreateTensor<float>(memory_info,
                                                                  input_data.data(), input_data.size(),
                                                                  input_shape.data(), input_shape.size());

        std::array<float, 6> output_data{};
        std::array<int64_t, 2> output_shape{3, 2};
        Ort::Value output_tensor = Ort::Value::CreateTensor<float>(memory_info,
                                                                   output_data.data(), output_data.size(),
                                                                   output_shape.data(), output_shape.size());

        const char* input_names[] = {"X"};
        const char* output_names[] = {"Y"};

        session.Run(Ort::RunOptions{nullptr}, input_names, &input_tensor, 1, output_names, &output_tensor, 1);

        std::array<float, 6> expected_data{1.0f, 4.0f, 9.0f, 16.0f, 25.0f, 36.0f};
        std::vector<int64_t> expected_shape{3, 2};

        auto type_info = output_tensor.GetTensorTypeAndShapeInfo();
        assert(type_info.GetShape() == expected_shape);
        auto total_len = type_info.GetElementCount();
        assert(total_len == expected_data.size());

        float* result = output_tensor.GetTensorMutableData<float>();
        for (size_t i = 0; i != total_len; ++i) {
          assert(expected_data[i] == result[i]);
        }

        std::cout << Ort::GetVersionString();
        return 0;
      }
    CPP

    require "base64"
    mul_1_onnx = "CAMSBmNoZW50YTpwChUKAVgKAVcSAVkaBW11bF8xIgNNdWwSCG11bCB0ZXN" \
                 "0KiMIAwgCEAEiGAAAgD8AAABAAABAQAAAgEAAAKBAAADAQEIBV1oTCgFYEg" \
                 "4KDAgBEggKAggDCgIIAmITCgFZEg4KDAgBEggKAggDCgIIAkIECgAQBw=="
    (testpath/"mul_1.onnx").write Base64.decode64(mul_1_onnx)

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc", "-L#{lib}", "-lonnxruntime", "-o", "test"
    output_lines = shell_output("./test 2>&1").lines

    # Remove warning messages that are safe to ignore
    output_lines.reject! { |line| line["Skipping pci_bus_id for PCI path"] }
    assert_equal version.to_s, output_lines.join
  end
end

__END__
diff --git a/onnxruntime/core/session/onnxruntime_c_api.cc b/onnxruntime/core/session/onnxruntime_c_api.cc
index b60d97e38f..6951642edb 100644
--- a/onnxruntime/core/session/onnxruntime_c_api.cc
+++ b/onnxruntime/core/session/onnxruntime_c_api.cc
@@ -45,6 +45,8 @@
 #include "core/session/ort_env.h"
 #include "core/session/utils.h"
 
+#include "onnx/onnxruntime_fix.h"
+
 #if defined(USE_CUDA) || defined(USE_CUDA_PROVIDER_INTERFACE)
 #include "core/providers/cuda/cuda_provider_factory.h"
 #include "core/providers/cuda/cuda_execution_provider_info.h"
@@ -3094,6 +3096,13 @@ ORT_API(const char*, OrtApis::GetBuildInfoString) {
 }
 
 const OrtApiBase* ORT_API_CALL OrtGetApiBase(void) NO_EXCEPTION {
+  class RunONNXRuntimeFix {
+   public:
+    RunONNXRuntimeFix() {
+      onnx::ONNXRuntimeFix::disableStaticRegistration();
+    }
+  };
+  static RunONNXRuntimeFix runONNXRuntimeFix;
   return &ort_api_base;
 }
 
