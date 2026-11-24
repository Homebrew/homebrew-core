class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "2f23784e27d210a23b059a847c305e305034fb4a842fface3ff37283f85a2b40"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    manifest_sha256 "7a65cba483e9ac2c71b18eed61f6f9a6079a25a79a0773139e985c601ce0da6d"
    sha256 cellar: :any, arm64_golden_gate: "cb4dd9f517f285a3a252ac9437ad2271d7eb5797cb7cdeff6adda5ef42450ef7"
    sha256 cellar: :any, arm64_tahoe:       "651b991b8b83aeeae108a2efdc2a1289744807928659c95e470d463a697a3677"
    sha256 cellar: :any, arm64_sequoia:     "7c6eec29eb6829b7d7e17740a36d02112113446a3f3379b0b78d9feadd66b80b"
    sha256 cellar: :any, arm64_linux:       "1ec8824b4abd68f920fc30905b041bece2754504bb9ba73a12b50c6cdcb3466a"
    sha256 cellar: :any, x86_64_linux:      "fbf395b76bc944268ca72e890a78d76955d2aaeed71d9019c11c15f930fe3ca0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "protobuf"

  uses_from_macos "python" => :build

  def install
    # FIXME: From v1.22+, onnx internals are hidden by default, which breaks
    # onnxruntime's usage of onnx as a dependency. We need to make them visible again.
    inreplace "CMakeLists.txt", "CXX_VISIBILITY_PRESET hidden", "CXX_VISIBILITY_PRESET default"

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DONNX_USE_LITE_PROTO=ON
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPython3_EXECUTABLE=#{which("python3")}
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # strip abseil linkage

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
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      find_package(Protobuf CONFIG REQUIRED)
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
