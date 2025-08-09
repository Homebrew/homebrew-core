class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.22.1",
      revision: "89746dc19a0a1ae59ebf4b16df9acab8f99f3925"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b48151d81d6e89715b3f2582c80cbf62bf00b2a229262e2a647523f0e581b9e"
    sha256 cellar: :any,                 arm64_sonoma:  "041c52b489e25d2c01796435018620cc6c6900ebbed8e66d6815daf6409d0cdc"
    sha256 cellar: :any,                 arm64_ventura: "b14526c37060420909e659c4c053f5622020baa0b55f35c7665b686fc5c6c44b"
    sha256 cellar: :any,                 sonoma:        "3bee396729875cfccb30ff43fe4b73daad7d331e385c6e7dc1845f02a88bd1ec"
    sha256 cellar: :any,                 ventura:       "e784591d56b936f385cfb026d85a798d30f2f10859419256e8104bcca7799028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b717f94d91eca7d0f2b92f59f073c1526b0c7fe98a3142cbb5fea645a2edd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ea882328d35156bbdf36ece96bf0f4b6e5364771be8e2b3342bf222030746a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.13" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "nsync"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  # Need newer than stable `eigen` after https://github.com/microsoft/onnxruntime/pull/21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  #
  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L25
  resource "eigen3" do
    url "https://gitlab.com/libeigen/eigen/-/archive/1d8b82b0740839c0de7f1242a3585e3390ff5f33/eigen-1d8b82b0740839c0de7f1242a3585e3390ff5f33.tar.bz2"
    sha256 "37c2385d5b18471d46ac8c971ce9cf6a5a25d30112f5e4a2761a18c968faa202"
  end

  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L51
  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/8a1772a0c5c447df2d18edf33ec4603a8c9c04a6.tar.gz"
    sha256 "37bb2fd2d1e87102baea8d131a0c550c4ceff5a12fba61faeb1bff63868155f1"
  end

  def install
    python3 = which("python3.13")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}/build/_deps/pytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf"].opt_bin}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <onnxruntime/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
