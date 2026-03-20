class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2026.0.0.tar.gz"
  sha256 "529ce766bcca30991c21d0e065886e175b5210d81d6f6b3d7cdaaa89fe22ea8a"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "29f2e1dd25e2351c38ec2d8766eaf373527440b5573c9fb6bffb345333aada66"
    sha256 cellar: :any, arm64_sequoia: "e24d12cb8c64e4f68be7ad98866bbe2c1d83ef53e4261d488673151ef99ddc73"
    sha256 cellar: :any, arm64_sonoma:  "fc397260128ff85fa9e2e45a8a36fe033e04cf840e4a0ba6c5d72e0578d77114"
    sha256 cellar: :any, sonoma:        "906f306eec3b1369498f817fd8949aa9af66df10b3d8277c487bbfc694c0cdf4"
    sha256               arm64_linux:   "58d8478acec9e4af84f4f2dd78382676360cceb5d89f2fda6ee550643bf8e685"
    sha256               x86_64_linux:  "ae1de6b4c0d376e4ed309bd145c7e6c7f11cc8e74759ff9cd9b2c509f2a043d8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "abseil"
  depends_on "nlohmann-json"
  depends_on "numpy"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://github.com/uxlfoundation/oneDNN/archive/929fe4e5629be2a5e89f1ba13b13458b965ffe57.tar.gz"
      sha256 "a646e1e702a856e0e99b3925f0ead792194c9d62c1ed25e5cbd18927320617e6"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/007264fa740de5723ebddef16b7bb3657692c088.tar.gz"
      sha256 "f743953fb0d91f6ef69712ec81bd5921dc1fc08af5e6bbb8645a4595ca9c6fd7"
    end
    resource "arm_kleidiai" do
      url "https://github.com/ARM-software/kleidiai/archive/7d82645ca2f3c3d58a5c0b1a96905e53916c8ff8.tar.gz"
      sha256 "7f6dc8992d229d5a0be8c2dec09011bab7c45201ed06ae60fbcd3c9343d09368"
    end
  end

  # FIXME: depends_on "pybind11" => :build
  #
  # error: static assertion failed due to requirement '0 == detail::constexpr_sum(
  # detail::is_instantiation<pybind11::call_guard, pybind11::is_method>::value, ...)':
  # def_property family does not currently support call_guard. Use a py::cpp_function instead
  resource "pybind11" do
    url "https://github.com/pybind/pybind11/archive/refs/tags/v3.0.1.tar.gz"
    sha256 "741633da746b7c738bb71f1854f957b9da660bcd2dce68d71949037f0969d0ca"
  end

  # FIXME: depends_on "xbyak" => :build
  #
  # compute_hash.cpp:418:53: error: use of overloaded operator '+' is ambiguous
  # (with operand types 'RegistersPool::Reg<Xbyak::Reg64>' and 'const uint64_t'
  # after https://github.com/herumi/xbyak/commit/689767da682edab65b55e9607535c28902370b08
  resource "xbyak" do
    on_intel do
      url "https://github.com/herumi/xbyak/archive/refs/tags/v7.28.tar.gz"
      sha256 "c8da3d85fa322303cb312d6315592547952d7bb81f58bf98bc0a26ecd88be495"
    end
  end

  resource "mlas" do
    url "https://github.com/openvinotoolkit/mlas/archive/d1bc25ec4660cddd87804fcf03b2411b5dfb2e94.tar.gz"
    sha256 "0a44fbfd4b13e8609d66ddac4b11a27c90c1074cde5244c91ad197901666004c"
  end

  resource "onednn_cpu" do
    url "https://github.com/openvinotoolkit/oneDNN/archive/c6b79c1207bd5f20b9395536dab1d71a47cfcb1d.tar.gz"
    sha256 "c6825a7aad5bc83686da759aeb89cf979bd820ba4795b55241fde0d6b093f4d6"
  end

  resource "openvino-telemetry" do
    url "https://files.pythonhosted.org/packages/71/8a/89d82f1a9d913fb266c2e6dc2f6030935db24b7152963a8db6c4f039787f/openvino_telemetry-2025.2.0.tar.gz"
    sha256 "8bf8127218e51e99547bf38b8fb85a8b31c9bf96e6f3a82eb0b3b6a34155977c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  def python3
    "python3.14"
  end

  def install
    # Work around for Protobuf C++ 6.x until OpenVINO adds support
    inreplace "thirdparty/dependencies.cmake", "find_package(Protobuf 5.26.0 ",
                                               "find_package(Protobuf 7.34.0 "

    # FIXME: workaround for
    #   CMake Error at cmake/developer_package/version.cmake:102 (message):
    # OpenVINO_VERSION_MAJOR parsed from CI_BUILD_NUMBER () and from
    # openvino/core/version.hpp (2025) are different
    # ENV["CI_BUILD_NUMBER"] = "#{version}-#{revision}-"

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

    resource("mlas").stage buildpath/"src/plugins/intel_cpu/thirdparty/mlas"
    resource("onednn_cpu").stage buildpath/"src/plugins/intel_cpu/thirdparty/onednn"
    resource("onednn_gpu").stage buildpath/"src/plugins/intel_gpu/thirdparty/onednn_gpu" if OS.linux?
    resource("pybind11").stage buildpath/"src/bindings/python/thirdparty/pybind11"

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath/"src/plugins/intel_cpu/thirdparty/ComputeLibrary"
      resource("arm_kleidiai").stage buildpath/"src/plugins/intel_cpu/thirdparty/kleidiai"
    else
      # TODO: Remove once able to build with xbyak >= 7.29
      resource("xbyak").stage buildpath/"thirdparty/xbyak"
    end

    # Fix pybind11 3.0+ def_property call_guard incompatibility, upstream bug report, https://github.com/openvinotoolkit/openvino/issues/34426
    inreplace "src/bindings/python/src/pyopenvino/core/core.cpp" do |s|
      pattern = /\s+py::call_guard<py::gil_scoped_release>\(\),\n/
      s.gsub!(pattern, "")
    end
    inreplace "src/bindings/python/src/pyopenvino/core/infer_request.cpp" do |s|
      pattern = /\s+py::call_guard<py::gil_scoped_release>\(\),\n/
      s.gsub!(pattern, "")
    end

    cmake_args = %w[
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_OV_JAX_FRONTEND=OFF
      -DENABLE_PROFILING_ITT=OFF
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
      -DProtobuf_USE_STATIC_LIBS=OFF
      -DOV_FORCE_ADHOC_SIGN=ON
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version}.0"
    end

    # Fix linking failure of certain binaries as Scons disables superenv
    cmake_args << "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib" if OS.linux? && Hardware::CPU.arm?

    openvino_binary_dir = "#{buildpath}/build"
    system "cmake", "-S", ".", "-B", openvino_binary_dir, *cmake_args, *std_cmake_args
    system "cmake", "--build", openvino_binary_dir
    system "cmake", "--install", openvino_binary_dir

    # build & install python bindings
    ENV["OPENVINO_BINARY_DIR"] = openvino_binary_dir
    ENV["PY_PACKAGES_DIR"] = site_packages = Language::Python.site_packages(python3)
    ENV["WHEEL_VERSION"] = version
    ENV["SKIP_RPATH"] = "1"
    ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
    ENV["CPACK_GENERATOR"] = "BREW"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: libexec/site_packages/"openvino")}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: libexec/site_packages/"openvino/frontend/onnx")}"

    # Allow our newer `numpy`
    inreplace "pyproject.toml", "numpy>=1.16.6,<2.5.0", "numpy>=1.16.6"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    venv.pip_install_and_link "."
    (prefix/Language::Python.site_packages(python3)/"homebrew-openvino.pth").write venv.site_packages
  end

  test do
    pkg_config_flags = shell_output("pkgconf --cflags --libs openvino tbb pugixml").chomp.split

    (testpath/"openvino_available_devices.c").write <<~C
      #include <openvino/c/openvino.h>
      #include <stdio.h>

      #define OV_CALL(statement) do {                                       \
          int _ov_status = (statement);                                     \
          if (_ov_status != 0) {                                            \
              fprintf(stderr, "OV_CALL failed: %s at %s:%d (status=%d)\\n", \
                      #statement, __FILE__, __LINE__, _ov_status);          \
              return 1;                                                     \
          }                                                                 \
      } while (0)

      int main() {
          ov_core_t* core = NULL;
          char* ret = NULL;
          OV_CALL(ov_core_create(&core));
          OV_CALL(ov_core_get_property(core, "CPU", "AVAILABLE_DEVICES", &ret));
      #if !defined(__APPLE__) && !defined(__aarch64__)
          // FIXME: checking `GPU` fails on aarch64 Linux.
          OV_CALL(ov_core_get_property(core, "GPU", "AVAILABLE_DEVICES", &ret));
      #endif
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_PROPERTIES", &ret));
          ov_core_free(core);
          return 0;
      }
    C
    system ENV.cc, testpath/"openvino_available_devices.c", *pkg_config_flags,
                   "-o", testpath/"openvino_devices_test"
    system testpath/"openvino_devices_test"

    (testpath/"openvino_available_frontends.cpp").write <<~CPP
      #include <openvino/frontend/manager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    CPP
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    CMAKE

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output(testpath/"openvino_frontends_test").strip

    system python3, "-c", <<~PYTHON
      import openvino as ov
      assert '#{version}' in ov.__version__
      ov.Core()
    PYTHON
  end
end
