class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  license "Apache-2.0"
  revision 10

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e337f975ab805aec26891978915d578377067eb42cff6628bb1982d829b2be3e"
    sha256 cellar: :any, arm64_sequoia: "6c2fb47288ff8c48e45deb6e65a8052a270c9848fe0942a5888b2f22837cd2b5"
    sha256 cellar: :any, arm64_sonoma:  "1f26d0ddccfe54db6fcb178b02b0fbcebe5f326db5b4a23ae4db92bedaaa918c"
    sha256 cellar: :any, sonoma:        "106412e0003bcba6c802fc9470afdcdf803c960e3bd47b83a0062249b56f999a"
    sha256               arm64_linux:   "f40be03d154f58f48a7b1487cf6e925132c9d557f1775cb4ae387309b161703d"
    sha256               x86_64_linux:  "7d0fe121a68153a54751e75a51d76bebc00bb6f1d79f3f0193fc47bb9fba38d9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

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
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://github.com/onnx/onnx/blob/main/onnx/test/cpp/ir_test.cc
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cctype>
      #include <memory>
      #include <string>
      #include <onnx/common/ir.h>
      #include <onnx/common/ir_pb_converter.h>
      using namespace onnx;

      bool IsValidIdentifier(const std::string& name) {
        if (name.empty()) {
          return false;
        }
        if (!isalpha(name[0]) && name[0] != '_') {
          return false;
        }
        for (size_t i = 1; i < name.size(); ++i) {
          if (!isalnum(name[i]) && name[i] != '_') {
            return false;
          }
        }
        return true;
      }

      int main() {
        Graph* g = new Graph();
        g->setName("test");
        Value* x = g->addInput();
        x->setUniqueName("x");
        x->setElemType(TensorProto_DataType_FLOAT);
        x->setSizes({Dimension("M"), Dimension("N")});
        Node* node1 = g->create(kNeg, 1);
        node1->addInput(x);
        g->appendNode(node1);
        Value* temp1 = node1->outputs()[0];
        Node* node2 = g->create(kNeg, 1);
        node2->addInput(temp1);
        g->appendNode(node2);
        Value* y = node2->outputs()[0];
        g->registerOutput(y);

        ModelProto model;
        ExportModelProto(&model, std::shared_ptr<Graph>(g));

        for (auto& node : model.graph().node()) {
          for (auto& name : node.output()) {
            assert(IsValidIdentifier(name));
          }
        }
        return 0;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
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
