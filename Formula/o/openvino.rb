class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2025.4.1.tar.gz"
  sha256 "9926c8a8188d0baa9730623efaeb9f0bccf7059f5e4e957a8d238c3226c2b19b"
  license "Apache-2.0"
  revision 3
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b7895df6f9ee49841183ca7abee864afd873a0551f8ce670c63fd5a2233721cb"
    sha256 cellar: :any, arm64_sequoia: "7c35f852dd76bb733c65c0cdd03697e4d15302d26a06d3bf3a26076c7fe06383"
    sha256 cellar: :any, arm64_sonoma:  "c77e0be7587b288bf16e5c16841d7a9596f6df42ce25b05b04d12ff42759c221"
    sha256 cellar: :any, sonoma:        "6cb024e7254ef5c1d8e8383a886bf6b08f46d18baf1a16141f46d3fe86e63f2c"
    sha256               arm64_linux:   "d92af382c49e55fb26cb62dc75e5d83b7b4acc88def02fbe24ddc10a72e1a06c"
    sha256               x86_64_linux:  "bc3a2cfc540d30861b2d4a0979c7c4dfd975490ca091c87c0a807582141e4643"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pybind11" => :build
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
      url "https://github.com/uxlfoundation/oneDNN/archive/29d64fe0ec0f1f20d7f80aa76630d58a6011a869.tar.gz"
      sha256 "90139a1193b9773f94ff3310cd6118d3b6ccf1adb24461c84aa87890caa5ee77"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v25.03.tar.gz"
      sha256 "30f83cea6d338a0e33495c33c547b7b720027baff4c3eea66014709fdd52aaac"
    end
    resource "arm_kleidiai" do
      url "https://github.com/ARM-software/kleidiai/archive/eaf63a6ae9a903fb4fa8a4d004a974995011f444.tar.gz"
      sha256 "756fa3040ff23f78a4c3f4c1984a3814d78d302b0b5dc3f0b255322368aefc58"
    end
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
    url "https://github.com/openvinotoolkit/oneDNN/archive/a4ed4a789b6e0869e4f651bbfeff6878e91d388e.tar.gz"
    sha256 "6fe2fa4edd68b5f3448d80eaaf7d5d9d329d679d7d25f80d3800a4f199e86dae"
  end

  resource "openvino-telemetry" do
    url "https://files.pythonhosted.org/packages/71/8a/89d82f1a9d913fb266c2e6dc2f6030935db24b7152963a8db6c4f039787f/openvino_telemetry-2025.2.0.tar.gz"
    sha256 "8bf8127218e51e99547bf38b8fb85a8b31c9bf96e6f3a82eb0b3b6a34155977c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def python3
    "python3.14"
  end

  # Fix to initialize HWCAP2_I8MM properly
  # Remove patch when available in release.
  patch do
    url "https://github.com/openvinotoolkit/openvino/commit/168316c62b6022251dd11f4c5b9c0f85da3e425a.patch?full_index=1"
    sha256 "d905df259b708851651f9544e2f43b9339ec1174c0dfa9879817279534fc702d"
  end

  def install
    # Work around for Protobuf C++ 6.x until OpenVINO adds support
    inreplace "thirdparty/dependencies.cmake", "find_package(Protobuf 5.26.0 ",
                                               "find_package(Protobuf 6.30.0 "

    # cmake 4 build patch for third parties
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # FIXME: workaround for
    #   CMake Error at cmake/developer_package/version.cmake:102 (message):
    # OpenVINO_VERSION_MAJOR parsed from CI_BUILD_NUMBER () and from
    # openvino/core/version.hpp (2025) are different
    ENV["CI_BUILD_NUMBER"] = "#{version}-#{revision}-"

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

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath/"src/plugins/intel_cpu/thirdparty/ComputeLibrary"
      resource("arm_kleidiai").stage buildpath/"src/plugins/intel_cpu/thirdparty/kleidiai"
    else
      # TODO: Remove once able to build with xbyak >= 7.29
      resource("xbyak").stage buildpath/"thirdparty/xbyak"
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

    # Fix linking failure of certain binaries.
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
    inreplace "pyproject.toml", "numpy>=1.16.6,<2.4.0", "numpy>=1.16.6"
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
      import openvino.runtime as ov
      assert '#{version}' in ov.__version__
    PYTHON
  end
end
