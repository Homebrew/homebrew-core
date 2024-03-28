class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2024.0.0.tar.gz"
  sha256 "b3c257f8af9545ae68a6ea217173b2b2de9dd42d35e8703a7a51d76f4c2bfe2f"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb86de9e84da998b69a659311fb35c272968911aea5e841aa1edb69fd8bf0f64"
    sha256 cellar: :any,                 arm64_ventura:  "46eb2eb8b7bf2344a173cb3750ea6d342b458b4b5ae005eb2500b091beb8c7da"
    sha256 cellar: :any,                 arm64_monterey: "0cb9fbb8cc3ed505e70316cde4b482a39f1de8c78a800f1a68f6536c471ba0f4"
    sha256 cellar: :any,                 sonoma:         "7a5482987b73437ecfc8b49f0fba8f21e7ebcfc9075bf44bab29e0274a1a1959"
    sha256 cellar: :any,                 ventura:        "95f814da35c37be0b1a821dfd6ce0a0a4112313b19e9c7c1dca95603fa17bb9d"
    sha256 cellar: :any,                 monterey:       "af4d1185f371d20da874289ba8e383a03581e3dc9a75fc067df3df3ea68342f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7bfe946861ebfe34c358b9f693ceee47307f5c556f5d62db573dde79c008ef5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cython" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "numpy"
  depends_on "pugixml"
  depends_on "python-packaging"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://github.com/oneapi-src/oneDNN/archive/494af5f9921bdae98f1a0e2955fa7d76ff386c4f.tar.gz"
      sha256 "e2f36563cecf39197ad8d4f8b351ccc5a431085dad26e47c0ae6f0bb79149df7"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v23.08.tar.gz"
      sha256 "62f514a555409d4401e5250b290cdf8cf1676e4eb775e5bd61ea6a740a8ce24f"
    end
  end

  on_intel do
    depends_on "xbyak" => :build
  end

  resource "mlas" do
    url "https://github.com/openvinotoolkit/mlas/archive/d1bc25ec4660cddd87804fcf03b2411b5dfb2e94.tar.gz"
    sha256 "0a44fbfd4b13e8609d66ddac4b11a27c90c1074cde5244c91ad197901666004c"
  end

  resource "onednn_cpu" do
    url "https://github.com/openvinotoolkit/oneDNN/archive/f82148befdbdc9576ec721c9d500155ee4de8060.tar.gz"
    sha256 "7fce5c6b499ffe1a30c26b2d4e4a5193a38aa217b6f54e44eea52b21cf38a684"
  end

  resource "onnx" do
    url "https://github.com/onnx/onnx/archive/refs/tags/v1.15.0.tar.gz"
    sha256 "c757132e018dd0dd171499ef74fca88b74c5430a20781ec53da19eb7f937ef68"
  end

  def python3
    "python3.12"
  end

  def install
    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdparty/ocl
                      thirdparty/xbyak thirdparty/gflags
                      thirdparty/ittapi thirdparty/snappy
                      thirdparty/pugixml thirdparty/protobuf
                      thirdparty/onnx/onnx thirdparty/flatbuffers
                      src/plugins/intel_cpu/thirdparty/mlas
                      src/plugins/intel_cpu/thirdparty/onednn
                      src/plugins/intel_gpu/thirdparty/rapidjson
                      src/plugins/intel_gpu/thirdparty/onednn_gpu
                      src/plugins/intel_cpu/thirdparty/ComputeLibrary]
    dependencies.each { |d| (buildpath/d).rmtree }

    resource("onnx").stage buildpath/"thirdparty/onnx/onnx"
    resource("mlas").stage buildpath/"src/plugins/intel_cpu/thirdparty/mlas"
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
      -DCPACK_GENERATOR=BREW
      -DENABLE_SYSTEM_PUGIXML=ON
      -DENABLE_SYSTEM_TBB=ON
      -DENABLE_SYSTEM_PROTOBUF=ON
      -DENABLE_SYSTEM_FLATBUFFERS=ON
      -DENABLE_SYSTEM_SNAPPY=ON
    ]

    openvino_binary_dir = "#{buildpath}/build"
    system "cmake", "-S", ".", "-B", openvino_binary_dir, *cmake_args
    system "cmake", "--build", openvino_binary_dir
    system "cmake", "--install", openvino_binary_dir

    # build & install python bindings
    ENV["OPENVINO_BINARY_DIR"] = openvino_binary_dir
    ENV["PY_PACKAGES_DIR"] = Language::Python.site_packages(python3)
    ENV["WHEEL_VERSION"] = version
    ENV["SKIP_RPATH"] = "1"
    ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
    ENV["CPACK_GENERATOR"] = "BREW"

    system python3, "-m", "pip", "install", *std_pip_args, "./src/bindings/python/wheel"
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
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_PROPERTIES", &ret));
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
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    EOS

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}/openvino_frontends_test").strip

    system python3, "-c", <<~EOS
      import openvino.runtime as ov
      assert '#{version}' in ov.__version__
    EOS
  end
end
