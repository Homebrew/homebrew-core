class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2023.0.0.tar.gz"
  sha256 "f2787851d9012813b2bbc888b5bb01c5f6f0ab222783acfb8e1e55ea41d0026b"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb19d02da11d7ed370dacc19fd0b6b1681f5a9e638453b0af1228107a57a41fe"
    sha256 cellar: :any,                 arm64_monterey: "d3c1a8f5d20204b80d5a90df615e35e06055600ac38c1f7c501c7a3c1c9a48a8"
    sha256 cellar: :any,                 arm64_big_sur:  "dbeb97b8e1f6eba6261159b5ecdc9d58da947fa79a39ebc32b2ce806338980f0"
    sha256 cellar: :any,                 ventura:        "57b0a8c79792f4361adb1d237e5f001f470f2be188291647c10cbd574f956a00"
    sha256 cellar: :any,                 monterey:       "79c84050331973d1f05d6ed44f2613616b4652cbd5c7a4514fe8e6c42c625a79"
    sha256 cellar: :any,                 big_sur:        "2e65adce70e720771e8c48492721c54eefc8529b3869ca9ff0b18eeb4386d5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba829f134583684d97590c864bb177ec1be4debe370555059dda9f3684d64fb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf" => :build
  depends_on "python@3.11" => :build
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers"
    depends_on "opencl-headers"
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://github.com/oneapi-src/oneDNN/archive/f27dedbfc093f51032a4580198bb80579440dc15.tar.gz"
      sha256 "da57c2298a8e001718902f0b65b6d92c4a7897b35467e23bc24996dde43ec47b"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v23.02.1.tar.gz"
      sha256 "c3a443e26539f866969242e690cf0651ef629149741ee18732f954c734da6763"
    end
  end

  resource "ade" do
    url "https://github.com/opencv/ade/archive/refs/tags/v0.1.1f.tar.gz"
    sha256 "c316680efbb5dd3ac4e10bb8cea345cf26a6a25ebc22418f8f0b8ca931a550e9"
  end

  resource "ittapi" do
    url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.0.tar.gz"
    sha256 "36c42d3f2446ddfaa2d7dfa02dfaa79615933f1a68a72d7e4f1d70de7b56e2c9"
  end

  resource "xbyak" do
    url "https://github.com/herumi/xbyak/archive/refs/tags/v6.69.tar.gz"
    sha256 "7eb64e2c18527824402b16f26c6118ba82f40f57fe6e3ab05c6e2883246a04f1"
  end

  resource "onednn_cpu" do
    url "https://github.com/openvinotoolkit/oneDNN/archive/1c7bfabf1b26e6fb95fea1613e1d3d2bef1f6b54.tar.gz"
    sha256 "52921b3efab33d1710971c67318e8c00ee102b6369e4e9cea8fdf91a1d68e38e"
  end

  resource "onnx" do
    url "https://github.com/onnx/onnx/archive/refs/tags/v1.13.1.tar.gz"
    sha256 "090d3e10ec662a98a2a72f1bf053f793efc645824f0d4b779e0ce47468a0890e"
  end

  def install
    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdparty/ade thirdparty/ittapi
                      thirdparty/xbyak thirdparty/onnx/onnx
                      src/plugins/intel_cpu/thirdparty/onednn
                      src/plugins/intel_gpu/thirdparty/onednn_gpu
                      src/plugins/intel_cpu/thirdparty/ComputeLibrary]
    dependencies.each { |d| (buildpath/d).rmtree }

    resource("ade").stage buildpath/"thirdparty/ade"
    resource("ittapi").stage buildpath/"thirdparty/ittapi/ittapi"
    resource("xbyak").stage buildpath/"thirdparty/xbyak"
    resource("onnx").stage buildpath/"thirdparty/onnx/onnx"
    resource("onednn_cpu").stage buildpath/"src/plugins/intel_cpu/thirdparty/onednn"

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath/"src/plugins/intel_cpu/thirdparty/ComputeLibrary"
    elsif OS.linux?
      resource("onednn_gpu").stage buildpath/"src/plugins/intel_gpu/thirdparty/onednn_gpu"
    end

    cmake_args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_GNA=OFF
      -DENABLE_PYTHON=OFF
      -DENABLE_SAMPLES=OFF
      -DENABLE_COMPILE_TOOL=OFF
      -DCPACK_GENERATOR=BREW
      -DENABLE_SYSTEM_PUGIXML=ON
      -DENABLE_SYSTEM_TBB=ON
      -DENABLE_SYSTEM_PROTOBUF=ON
      -DENABLE_SYSTEM_FLATBUFFERS=ON
      -DENABLE_SYSTEM_SNAPPY=ON
    ]

    system "cmake", "-S", buildpath.to_s, "-B", "#{buildpath}/openvino_build", *cmake_args
    system "cmake", "--build", "#{buildpath}/openvino_build"

    # install only required components

    components = %w[core core_dev
                    cpu gpu batch multi hetero
                    ir onnx paddle pytorch tensorflow tensorflow_lite]
    components.each { |comp| system "cmake", "--install", "#{buildpath}/openvino_build", "--component", comp }
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs openvino").chomp.split

    (testpath/"openvino_available_devices.c").write <<~EOS
      #include <openvino/c/openvino.h>

      #define OV_CALL(statement) \
          if ((statement) != 0) \
              return 1;

      int main() {
          ov_core_t* core = NULL;
          char* ret = NULL;
          OV_CALL(ov_core_create(&core));
          OV_CALL(ov_core_get_property(core, "CPU", "AVAILABLE_DEVICES", &ret));
      #ifndef __APPLE__
          OV_CALL(ov_core_get_property(core, "GPU", "AVAILABLE_DEVICES", &ret));
      #endif
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_METRICS", &ret));
          ov_core_free(core);
          return 0;
      }
    EOS
    system ENV.cc, "#{testpath}/openvino_available_devices.c", *pkg_config_flags,
                   "-o", "#{testpath}/openvino_devices_test"
    system "#{testpath}/openvino_devices_test"

    (testpath/"openvino_available_frontends.cpp").write <<~EOS
      #include <openvino/frontend/manager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow Paddle)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    EOS

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}/openvino_frontends_test").strip
  end
end
