class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2022.3.0.tar.gz"
  sha256 "b8dc1880d9ab71bd24aa5b2565724c12fb78172613e23ce312e0b98a6d8a0dd7"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0adf07206e42e7b34de843e59c337cea43a691940f4392a08f71689f7d93ab33"
    sha256 cellar: :any,                 arm64_monterey: "bba738c28e237a7fd726c899bfaa672f7ad8aab78a0e1911fcfb2177775ac199"
    sha256 cellar: :any,                 arm64_big_sur:  "8c5eadbf56eae998cc5fea71e96c4521a623261943b52c8d87eb292afeb46136"
    sha256 cellar: :any,                 ventura:        "cd6624a3870c58c9da2e98f39d436c0e32bc993bd044cb1a197de65a64c2b2bc"
    sha256 cellar: :any,                 monterey:       "be04f666d2107db7519b19f57a392a570a5f0f28bb46f0008b80363d3a44226f"
    sha256 cellar: :any,                 big_sur:        "27c754180c1525835ab7a0dc40ce893511b1a9276c95c9dd4b87298145876d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adde2adfe752b29c58545e1c1eb203f870968ce4194fff50e6e9c30d9a49821"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gflags" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf" => :build
  depends_on "python@3.11" => :build
  depends_on "pugixml"
  depends_on "tbb"

  on_arm do
    depends_on "scons" => :build

    resource "openvino_contrib" do
      url "https://github.com/openvinotoolkit/openvino_contrib/archive/refs/tags/2022.3.0.tar.gz"
      sha256 "245e19b4a2c926aedb764fecbd02c5023deab56eba497e4a3c8194e760e26413"
    end

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v22.11.tar.gz"
      sha256 "e20a060d3c4f803889d96c2f0b865004ba3ef4e228299a44339ea1c1ba827c85"
    end
  end

  resource "onednn_cpu" do
    on_intel do
      url "https://github.com/openvinotoolkit/oneDNN/archive/44de3c3698b687c26e487fc8f0213fa487e8fe2c.tar.gz"
      sha256 "2c6aa7d787a947aa032224683f216ab38c168de4aed61d0554671774060a3615"
    end
  end

  resource "ade" do
    url "https://github.com/opencv/ade/archive/refs/tags/v0.1.1f.tar.gz"
    sha256 "c316680efbb5dd3ac4e10bb8cea345cf26a6a25ebc22418f8f0b8ca931a550e9"
  end

  resource "ittapi" do
    url "https://github.com/intel/ittapi/archive/refs/tags/v3.23.0.tar.gz"
    sha256 "9af1231808c602c2f7a66924c8798b1741d3aa4b15f3874d82ca7a89b5dbb1b1"
  end

  resource "xbyak" do
    url "https://github.com/herumi/xbyak/archive/refs/tags/v6.63.tar.gz"
    sha256 "16c60f0682502624115c4dc9fec66782ae68ef32e469946f50cd169179ea92bb"
  end

  resource "onnx" do
    url "https://github.com/onnx/onnx/archive/refs/tags/v1.12.0.tar.gz"
    sha256 "052ad3d5dad358a33606e0fc89483f8150bb0655c99b12a43aa58b5b7f0cc507"
  end

  def install
    resource("ade").stage buildpath/"thirdparty/ade"
    resource("ittapi").stage buildpath/"thirdparty/ittapi/ittapi"
    resource("xbyak").stage buildpath/"thirdparty/xbyak"
    resource("onnx").stage buildpath/"thirdparty/onnx/onnx"

    if Hardware::CPU.arm?
      resource("openvino_contrib").stage buildpath/"openvino_contrib"
      resource("arm_compute").stage buildpath/"openvino_contrib/modules/arm_plugin/thirdparty/ComputeLibrary"
    else
      resource("onednn_cpu").stage buildpath/"src/plugins/intel_cpu/thirdparty/onednn"
    end

    cmake_args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DENABLE_TBBBIND_2_5=OFF
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_INTEL_GPU=OFF
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_GNA=OFF
      -DENABLE_INTEL_MYRIAD_COMMON=OFF
      -DENABLE_PYTHON=OFF
      -DENABLE_SAMPLES=OFF
      -DENABLE_COMPILE_TOOL=OFF
      -DCPACK_GENERATOR=BREW
      -DENABLE_SYSTEM_PUGIXML=ON
      -DENABLE_SYSTEM_TBB=ON
      -DENABLE_SYSTEM_PROTOBUF=ON
    ]

    if Hardware::CPU.arm?
      cmake_args += %W[
        -DOPENVINO_EXTRA_MODULES=#{buildpath}/openvino_contrib/modules/arm_plugin
      ]
    end

    system "cmake", "-S", buildpath.to_s, "-B", "#{buildpath}/openvino_build", *cmake_args
    system "cmake", "--build", "#{buildpath}/openvino_build"

    # install only required components

    components = %w[core core_dev
                    cpu gpu batch multi hetero
                    ir onnx paddle pytorch tensorflow]
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
    assert_equal "4", shell_output("#{testpath}/openvino_frontends_test").strip
  end
end
