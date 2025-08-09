class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  license "Apache-2.0"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed90ec9ff47babc3a8f7e39c099035ec8facd5bab8e54c2e1b36dcc8c3a8c836"
    sha256 cellar: :any,                 arm64_sonoma:  "6ab93d5c23e294f5ae1fa673a3ff5ce243f007bdc1c4e29b331fd2169cad3f30"
    sha256 cellar: :any,                 arm64_ventura: "3cd4c926f52dfb80d477426a4239bfd1ea2adb8199a5a632360619d710b88157"
    sha256 cellar: :any,                 sonoma:        "a8da2d05a39dd07e0afb577456d5dc705ef6df2d383beb535b7fb7ec709565a0"
    sha256 cellar: :any,                 ventura:       "4796b3c405ca858390745034da1ed1ca0a2556e09a1f94717aecb951a6bf5f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "002cfa8f0251bf6eaf4cd4b591cd102c872bf74feeca67428d1032f7c0840b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9616ae7d1c8043f6d8ca813658be94493e11be7038aa85f97e0b6ceef66081c8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

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
