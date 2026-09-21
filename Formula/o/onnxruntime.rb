class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "f6681ecbddf53898adf0cc9e8e9e84657485b84d2eca3c8aa353de6d7dd417ef"
  license "MIT"
  revision 1
  compatibility_version 9

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a4c4cd6a597708260e5d5ae8c803c51f38b35823f1f14f2e5de1f42f2106d90"
    sha256 cellar: :any, arm64_tahoe:       "cf0f6e381b96d4c9b43e570719c1b17a1de8ddd9103c9fecde039ded9a998403"
    sha256 cellar: :any, arm64_sequoia:     "5fef971df76a944014ec5f8e847e67935b586b1ba77c75759bf8588fe8b15113"
    sha256 cellar: :any, arm64_linux:       "386b79bfa33b449cbba5eb2ab267855761c83afea5f4e966468dacc3159b4094"
    sha256 cellar: :any, x86_64_linux:      "858e34ec135406c1b75aae36cdc3a32e97cba58a8de77ad438333c4d0765262b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
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

  # `cpp-gsl` 5.0.0 fails the `find_package(Microsoft.GSL 4.0)` version check
  # (its config uses `SameMajorVersion`), so vendor the pinned version instead.
  resource "gsl" do
    url "https://github.com/microsoft/GSL/archive/refs/tags/v4.2.1.tar.gz"
    sha256 "d959f1cb8bbb9c94f033ae5db60eaf5f416be1baa744493c32585adca066fe1f"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^microsoft_gsl;.*/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/66ee79c038d70dad9f08705b2c9b3e58f6d8f512.tar.gz"
    version "66ee79c038d70dad9f08705b2c9b3e58f6d8f512"
    sha256 "e3d09aa27ec50da6310da45d1ec6b2e903c367a1455d8ee350bda12b9dedf556"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^pytorch_cpuinfo;.*/(\h+)\.zip}i)
    end
  end

  resource "coremltools" do
    url "https://github.com/apple/coremltools/archive/refs/tags/7.1.tar.gz"
    sha256 "d3222966982367b2be4ce62f1bd2b3dddc5a0ae018724a9acf850fbf2b0cc09a"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^coremltools;.*/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  resource "fp16" do
    url "https://github.com/Maratyszcza/FP16/archive/0a92994d729ff76a58f692d3028ca1b64b145d91.tar.gz"
    version "0a92994d729ff76a58f692d3028ca1b64b145d91"
    sha256 "a91f4770ff9c39f4d72e339c379f566b3bbb359fa66122d85fc0bae3dde7abc7"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^fp16;.*/(\h+)\.zip}i)
    end
  end

  resource "psimd" do
    url "https://github.com/Maratyszcza/psimd/archive/072586a71b55b7f8c584153d223e95687148a900.tar.gz"
    version "072586a71b55b7f8c584153d223e95687148a900"
    sha256 "f6c4dab91ae9a03b3019e7cab0572743afd0e1b6e75b97fcca50259c737c924e"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^psimd;.*/(\h+)\.zip}i)
    end
  end

  def install
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_MP11=#{formula_opt_prefix("boost")}
      -DPython_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{formula_opt_bin("protobuf")}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=OFF
    ]

    args << if OS.mac?
      "-Donnxruntime_USE_COREML=ON"
    else
      "-Donnxruntime_USE_COREML=OFF"
    end

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = formula_opt_bin("flatbuffers")/"flatc"
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
      #ifdef __APPLE__
      #include <Availability.h>
      #include <onnxruntime/coreml_provider_factory.h>
      #endif

      int main(void) {
        Ort::Env ort_env;
        Ort::SessionOptions so;
        #if defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 150000
        uint32_t coreml_flags = 0;
        Ort::ThrowOnError(OrtSessionOptionsAppendExecutionProvider_CoreML(so, coreml_flags));
        #endif
        Ort::Session session{ort_env, "mul_1.onnx", so};
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

    mul_1_onnx = "CAMSBmNoZW50YTpwChUKAVgKAVcSAVkaBW11bF8xIgNNdWwSCG11bCB0ZXN" \
                 "0KiMIAwgCEAEiGAAAgD8AAABAAABAQAAAgEAAAKBAAADAQEIBV1oTCgFYEg" \
                 "4KDAgBEggKAggDCgIIAmITCgFZEg4KDAgBEggKAggDCgIIAkIECgAQBw=="
    (testpath/"mul_1.onnx").write mul_1_onnx.unpack1("m")

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc", "-L#{lib}", "-lonnxruntime", "-o", "test"
    output_lines = shell_output("./test 2>&1").lines

    # Remove warning messages that are safe to ignore
    output_lines.reject! { |line| line["Skipping pci_bus_id for PCI path"] }
    assert_equal version.to_s, output_lines.join
  end
end
