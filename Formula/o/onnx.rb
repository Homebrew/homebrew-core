class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "9bcd6473c689b1ac3aeba8df572891756e01c1a151ae788df5cbc7a4499e5db5"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f22d77e26cb864c3990c516952526a30fa2b8a5492054ec8384f10cd28459540"
    sha256 cellar: :any,                 arm64_sequoia: "01951a01a4af1ce69ad047373712b72767c2c33b847819104ee52f88b014143e"
    sha256 cellar: :any,                 arm64_sonoma:  "a70ccf2167ecf579e3fd5c5a6ccc0222d44bfd1856cc3643daa2be3defb2571a"
    sha256 cellar: :any,                 sonoma:        "e05df17cd26ecc9f591a0df00c385b698a52ea5c1f1d52cde39774681b22b15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf55c1b857347776dc0c2d355e492f27c4fa3fdf430ec1860523799330bcef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7a4dfd057c361fb43014b1f85e29bb9da7b5649d96af923a328bc38f7e33f7"
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
      -DONNX_USE_LITE_PROTO=ON
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPython3_EXECUTABLE=#{which("python3")}
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
