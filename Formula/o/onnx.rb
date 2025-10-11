class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  # TODO: Check if workarounds can be dropped,
  # - https://github.com/onnx/onnx/issues/7377
  # - https://github.com/onnx/onnx/issues/7378
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "2c2ac5a078b0350a0723fac606be8cd9e9e8cbd4c99bab1bffe2623b188fd236"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "81b64f196d68c01bb740a53aae9f7c9e088b240a741389f5a5d676cb01cbc7ae"
    sha256 cellar: :any, arm64_sequoia: "ff2c5310746525e6bc79ba0b7cbe8ce08ad826cccb3c7f937970ff342295fdc7"
    sha256 cellar: :any, arm64_sonoma:  "56f97c1ccabbd67c20a3c6d1c4c1733bc228a018e90e6db51c69f7ea051e642d"
    sha256 cellar: :any, sonoma:        "2dad70397d478bb86df821d42c2ce0fe195b789c3dc156868e6f208c4188438a"
    sha256               arm64_linux:   "d81d331edfa586d1904fd3fd47f99f254967bd89de1a63bef07745b32a83066c"
    sha256               x86_64_linux:  "962b238222306fb53e1581df8d1474e1b6bcfd0dcce0cc895cdf21862bf1aeb3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

  # Apply ONNX Runtime's patch to remove explicit keyword so we can use `onnx` as dependency
  patch do
    url "https://raw.githubusercontent.com/microsoft/onnxruntime/ecb26fb7754d7c9edf24b1844ea807180a2e3e23/cmake/patches/onnx/onnx.patch"
    sha256 "ab8de8ea01a9981b9b0d001b00685d6f264e141285ba183a90d8da388be45a3e"
  end

  # Apply Fedora's workaround to allow `onnxruntime` to use `onnx` built without
  # ONNX_DISABLE_STATIC_REGISTRATION[^1]. We can't use this option as it will
  # break functionality for any dependents/users expecting the default behavior.
  #
  # [^1]: https://github.com/microsoft/onnxruntime/issues/8556#issuecomment-1006091632
  patch do
    url "https://src.fedoraproject.org/rpms/onnx/raw/4de8a450afd87b1ba1931f50d841e9c50b63d8a0/f/0004-Add-fixes-for-use-with-onnxruntime.patch"
    sha256 "d9ddb735c065fd5dae11ab79371e62bdcca157a6d2a7705cc83ee612abeaaa98"
  end

  def install
    if OS.mac?
      inreplace "CMakeLists.txt" do |s|
        # Disable hidden visibility for onnx_proto to fix build: https://github.com/onnx/onnx/issues/7377
        # TODO: Remove when upstream issue is resolved
        s.gsub! "set_target_properties(onnx_proto PROPERTIES CXX_VISIBILITY_PRESET hidden)", ""

        # Also remove hidden visibility in onnx as needed by onnxruntime
        s.gsub! "set_target_properties(onnx PROPERTIES CXX_VISIBILITY_PRESET hidden)", ""
      end
    end

    # Workaround for regression in ONNXConfig.cmake: https://github.com/onnx/onnx/issues/7378
    inreplace "cmake/ONNXConfig.cmake.in",
              "if((NOT @@ONNX_USE_PROTOBUF_SHARED_LIBS@@) AND @@Build_Protobuf@@)",
              "if(ON)"

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPython3_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://github.com/onnx/onnx/blob/main/onnx/test/cpp/function_verify_test.cc
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <onnx/defs/parser.h>
      #include <onnx/shape_inference/implementation.h>

      int main(void) {
        const char* code = R"ONNX(
      <
        ir_version: 8,
        opset_import: [ "" : 13, "custom_domain_1" : 1, "custom_domain_2" : 1],
        producer_name: "FunctionProtoTest",
        producer_version: "1.0",
        model_version: 1,
        doc_string: "A test model for model local functions."
      >
      agraph (float[N] x) => (uint8[N] out)
      {
          o1, o2 = custom_domain_1.bar(x)
          o3 = Add(o1, o2)
          o4 = custom_domain_2.foo(o3)
          out = Identity(o4)
      }

      <
        domain: "custom_domain_1",
        opset_import: [ "" : 13],
        doc_string: "Test function proto"
      >
      bar (x) => (o1, o2) {
            o1 = Identity (x)
            o2 = Identity (o1)
      }

      <
        domain: "custom_domain_2",
        opset_import: [ "" : 13],
        doc_string: "Test function proto"
      >
      foo (x) => (y) {
            Q_Min = Constant <value = float[1] {0.0}> ()
            Q_Max = Constant <value = float[1] {255.0}> ()
            X_Min = ReduceMin <keepdims = 0> (x)
            X_Max = ReduceMax <keepdims = 0> (x)
            X_Range = Sub (X_Max, X_Min)
            Scale = Div (X_Range, Q_Max)
            ZeroPoint_FP = Sub (Q_Min, Scale)
            Zeropoint = Cast <to = 2> (ZeroPoint_FP)
            y = QuantizeLinear (x, Scale, Zeropoint)
      }
      )ONNX";

        onnx::ModelProto model;
        auto status = onnx::OnnxParser::Parse(model, code);
        assert(status.IsOK());

        onnx::ShapeInferenceOptions options{true, 1, true};
        onnx::shape_inference::InferShapes(model, onnx::OpSchemaRegistry::Instance(), options);
        return 0;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      find_package(ONNX CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test ONNX::onnx)
    CMAKE

    ENV.delete "CPATH"
    args = ["-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"]
    args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
