class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.22.0",
      revision: "f217402897f40ebba457e2421bc0a4702771968e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f86b87a8fb5510d6f8c05918ba95c9d5c8ed00daa61cb01bb189d6523ae6f92"
    sha256 cellar: :any,                 arm64_sonoma:  "a4351dd4c5f4fe151b0053d8d3826e9456271cfab20dfeed65e2f8fb4f981e17"
    sha256 cellar: :any,                 arm64_ventura: "031529e7abd12c6d314a8bb9b02b9411134c593aeeb203afa798381954a430ae"
    sha256 cellar: :any,                 sonoma:        "989b25e16644e5e6ca672ffd17dc03d4db442a22315d5b7ee6072f8c329e380a"
    sha256 cellar: :any,                 ventura:       "1e370da96913bbf6a18d94ecf11e80eeef02eac9bf238d05cbee11f4b8e212fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8de910a50997637a731b2cd3af8525524f8e398bda38b0fc285bdd82acae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421226c4a5e4c1f469d12197715dddf281b167fe6c4db790a2280eec9d0e7f0d"
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
