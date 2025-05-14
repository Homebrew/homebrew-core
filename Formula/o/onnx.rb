class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://github.com/onnx/onnx/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "b466af96fd8d9f485d1bb14f9bbdd2dfb8421bc5544583f014088fb941a1d21e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "87e803d38d384328e30a6104d461aa429168f34f90166034effa1f2393e68cc2"
    sha256 cellar: :any,                 arm64_sonoma:  "24042b9d2631f8eaa656651f4d8ae2c0bcf21c9494ad83af0d4157171df0a1dd"
    sha256 cellar: :any,                 arm64_ventura: "4ea1894f1dbcf250d0a5a8fc6189dae1223c4c8f0540c6e2ce6ddb275d8e578a"
    sha256 cellar: :any,                 sonoma:        "d3d1459cffc0e2547efc589427b32bf67cf6d5e6daedf30c62747d7bc1bedb61"
    sha256 cellar: :any,                 ventura:       "657fa2a17084889403dc19a6385df4979c6bade3eea063e559668f387d5017c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8ade75bd41095e4e6104c6fa4f3a296c52c626a5fc58ff63c13d8d859e53a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9527543ac126f35a52e537eb66386e7a73abc22c197cfc6e5e199dd3eeb949ad"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
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
    (testpath/"ir_test.cpp").write <<~CPP
      #include <iostream>

      #include "gtest/gtest.h"
      #include "onnx/common/ir.h"
      #include "onnx/common/ir_pb_converter.h"
      #include "onnx/defs/printer.h"

      namespace ONNX_NAMESPACE {
      namespace Test {

      static bool IsValidIdentifier(const std::string& name) {
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

      TEST(IR, ValidIdentifierTest) {
        Graph* g = new Graph();
        g->setName("test");
        Value* x = g->addInput();
        x->setUniqueName("x");
        x->setElemType(ONNX_NAMESPACE::TensorProto_DataType_FLOAT);
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
            EXPECT_TRUE(IsValidIdentifier(name));
          }
        }
      }

      } // namespace Test
      } // namespace ONNX_NAMESPACE
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(ir_test LANGUAGES CXX)
      find_package(ONNX CONFIG REQUIRED)
      find_package(GTest REQUIRED)
      add_executable(ir_test ir_test.cpp)
      target_link_libraries(ir_test PRIVATE ONNX::onnx gtest gtest_main)
      enable_testing()
      add_test(NAME IRValidIdentifierTest COMMAND ir_test)
    CMAKE

    ENV.delete "CPATH"
    args = ["-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"]
    args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
