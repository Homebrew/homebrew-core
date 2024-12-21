class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2144e03e0a2c5414c3be8990425d71d5734d53edadcb74a6c587e5167bd123e"
    sha256 cellar: :any,                 arm64_sonoma:  "de643758f6f3dadc80300b4a842aaeed3837092d26422921eb32cbba2d591ecd"
    sha256 cellar: :any,                 arm64_ventura: "681bff0d190bb8df52d7e84f54d2fa2a1ce819976c1f7403d3f983a46245e20e"
    sha256 cellar: :any,                 sonoma:        "f34da28859b67f6450d39ac2efdc2952203d8887756a07a0e126ff166002735a"
    sha256 cellar: :any,                 ventura:       "cd411a76e28823c7d5e4e32db067a58414c9da18fe33fa0591d0a9c895316ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb60989003bffd5716dc752d9a62fba40dd21a5a4a77089d750c06fbeb7e06f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DONNX_USE_PROTOBUF_SHARED_LIBS=ON",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
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
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(ONNX CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test ONNX::onnx)
    CMAKE

    ENV.delete "CPATH"
    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib}"]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "./test"
  end
end
