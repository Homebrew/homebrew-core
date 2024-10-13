class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2024.4.1.tar.gz"
  sha256 "b8045c9d24be1f7247ed5e1055f5a2df745fb00d4820af2686b5c04eca113163"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08db97ef594be91f9e5ac60f0e7762f86821ca2606a67f4f90fa854f99017df1"
    sha256 cellar: :any,                 arm64_sonoma:  "325852c31c34d989df1a36a794ba3cb6a0250be477c1d07079db05e4c40305e0"
    sha256 cellar: :any,                 arm64_ventura: "f1344c24759b04c975ee35669b5fd808120446fb7374aa41a1799733d9f3cbc0"
    sha256 cellar: :any,                 sonoma:        "907d1976dabef9dbd228a5ed44aa762d691c69a1971de7b3c1517e2ea5fecb6e"
    sha256 cellar: :any,                 ventura:       "34d41a49064520427bd9402cd8e3962d53b138eaeb1161f3f1c45da8ec98d751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34f60bcb27eee29db774d2249a6b649e5b28e4ddf34ff7ca6fc482d28387b93"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "numpy"
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.6-pc.tar.gz"
      sha256 "d0eeff1425e318887c429a709d58010a580c8173eba8fbee74bca41b7f621f59"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v24.09.tar.gz"
      sha256 "49b8620f21cbbe49e825a131d9eacd548532646289b50e070b83860bd88087fe"
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
    url "https://github.com/openvinotoolkit/oneDNN/archive/c8ae8d96e963bd04214858319fa334968e5e73c9.tar.gz"
    sha256 "b9c2a53061b4528231ff5fbcee85900d698c329c7977b1f39c5d3d65f29c2caa"
  end

  resource "onnx" do
    url "https://github.com/onnx/onnx/archive/refs/tags/v1.16.0.tar.gz"
    sha256 "0ce153e26ce2c00afca01c331a447d86fbf21b166b640551fe04258b4acfc6a4"
  end

  resource "openvino-telemetry" do
    url "https://files.pythonhosted.org/packages/2b/c7/ca3bb8cfb17c46cf50d951e0f4dd4bf3f7004e0c207b25164df70e091f6d/openvino-telemetry-2024.1.0.tar.gz"
    sha256 "6df9a8f499e75d893d0bece3c272e798109f0bd40d1eb2488adca6a0da1d9b9f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
    dependencies.each { |d| rm_r(buildpath/d) }

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
      -DENABLE_JS=OFF
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_NPU=OFF
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

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    venv.pip_install_and_link "./src/bindings/python/wheel"
    (prefix/Language::Python.site_packages(python3)/"homebrew-openvino.pth").write venv.site_packages
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
