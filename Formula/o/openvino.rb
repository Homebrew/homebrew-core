class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://github.com/openvinotoolkit/openvino/archive/refs/tags/2026.4.1.tar.gz"
  sha256 "1ee85264556025486a4745a2d452ea823c578b3d162768bfef590366d2e6c539"
  license "Apache-2.0"
  compatibility_version 8
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9209c10a5f0b6a15a6b1d06cdad7a24c5021fcd3636b889fb2050fd63a623525"
    sha256 cellar: :any, arm64_tahoe:       "98daf1613ed8c342294903f4f37042360c3ae3f1ec5cdbb7934c582b3031fbb4"
    sha256 cellar: :any, arm64_sequoia:     "746feb262a779aff182d34b3586bc4a30e775bc3a383bdbe282d94bca91454b5"
    sha256               arm64_linux:       "b1bc0da7956e469b58879f1b10b3636c56d7e8825661b9789389095e0244fc68"
    sha256               x86_64_linux:      "2042ec60ab0a83f3bb5b59598ac323bbacf714a958266c2670c113ad40382406"
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
      url "https://github.com/uxlfoundation/oneDNN/archive/a3d459721b72c3a9d2685b46c03dafee7af0f25c.tar.gz"
      sha256 "cf6b29b5b41c8f2de1a05c3dd0013c4ee773724b0d20d6fa7dbb9b332e698180"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://github.com/ARM-software/ComputeLibrary/archive/7f8a8ab512ad8d1c1c207003ac5f96c4445da36f.tar.gz"
      sha256 "040222d5e80191dc3c1f6c855b35638d9e0b547f6c1bf81b0618778c26d8307c"
    end
    resource "arm_kleidiai" do
      url "https://github.com/ARM-software/kleidiai/archive/dc50c2e68d2eb28efe17c835c754f1d6421f30e8.tar.gz"
      sha256 "e2032ce93f2cdd2cd7f698ba2a5f216a446a12a8c918d79e7e398476dba80c8b"
    end
  end

  # Header only library, keep in sync with corresponded submodule version on release tag, i.e.
  # https://github.com/openvinotoolkit/openvino/tree/2026.4.0/thirdparty
  # currently there is no possibility to use latest xbyak from homebrew
  resource "xbyak" do
    on_intel do
      url "https://github.com/herumi/xbyak/archive/refs/tags/v7.37.tar.gz"
      sha256 "eb66c5d23d3983dd855cb230e0dcb02fa24307bdfa826844ec94491a344aacaf"
    end
  end

  resource "mlas" do
    url "https://github.com/openvinotoolkit/mlas/archive/d1bc25ec4660cddd87804fcf03b2411b5dfb2e94.tar.gz"
    sha256 "0a44fbfd4b13e8609d66ddac4b11a27c90c1074cde5244c91ad197901666004c"
  end

  resource "onednn_cpu" do
    url "https://github.com/openvinotoolkit/oneDNN/archive/1289c3b65dd6a119a5ed12a816517d9c3a21d81b.tar.gz"
    sha256 "726a93992e65152f338fa7bce536fa9ed6c9f395de80d1e55f01ecc3fece7f11"
  end

  resource "openvino-telemetry" do
    url "https://files.pythonhosted.org/packages/71/8a/89d82f1a9d913fb266c2e6dc2f6030935db24b7152963a8db6c4f039787f/openvino_telemetry-2025.2.0.tar.gz"
    sha256 "8bf8127218e51e99547bf38b8fb85a8b31c9bf96e6f3a82eb0b3b6a34155977c"
  end

  def install
    # Work around for Protobuf C++ 6.x until OpenVINO adds support
    inreplace "thirdparty/dependencies.cmake", "find_package(Protobuf 5.26.0 ",
                                               "find_package(Protobuf 7.34.0 "

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
      resource("xbyak").stage buildpath/"thirdparty/xbyak"
    end

    cmake_args = %w[
      -DENABLE_TESTS=OFF
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_OV_JAX_FRONTEND=OFF
      -DENABLE_OV_ZERO_LOADER=OFF
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
    if OS.linux? && Hardware::CPU.arm?
      # Issue 1: Fix linking failure of certain binaries as Scons disables superenv

      # Issue 2:
      # On Linux ARM64, OpenVINO's shared frontends can acquire direct NEEDED entries
      # for Abseil libraries through Homebrew's shared Protobuf/ONNX CMake targets
      # (e.g. protobuf::libprotobuf-lite -> absl::hash). OpenVINO's BREW packaging
      # RPATH only points at its own libdir, so add Homebrew's libdir explicitly to
      # let the dynamic loader resolve libabsl_*.so at runtime.
      rpaths = [
        lib,
        HOMEBREW_PREFIX/"lib",
        formula_opt_lib("abseil"),
        formula_opt_lib("protobuf"),
        formula_opt_lib("onnx"),
      ].uniq.join(";")

      inreplace "cmake/developer_package/packaging/common-libraries.cmake",
                'set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${OV_CPACK_LIBRARYDIR}")',
                "set(CMAKE_INSTALL_RPATH \"#{rpaths}\")"

      cmake_args << "-DCMAKE_BUILD_RPATH=#{rpaths}"
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # build & install python bindings
    ENV["OPENVINO_BINARY_DIR"] = buildpath/"build"
    ENV["PY_PACKAGES_DIR"] = site_packages = Language::Python.site_packages(python3)
    ENV["WHEEL_VERSION"] = version
    ENV["SKIP_RPATH"] = "1"
    ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
    ENV["CPACK_GENERATOR"] = "BREW"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: libexec/site_packages/"openvino")}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: libexec/site_packages/"openvino/frontend/onnx")}"

    inreplace "pyproject.toml" do |s|
      # Allow our newer `numpy`
      s.gsub! "numpy>=1.16.6,<2.6.0", "numpy>=1.16.6"
      # use our `cmake` instead of the PyPI cmake wheel
      s.gsub!(/^\s*"cmake[^"\n]*",?\s*\n/, "")
    end

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
