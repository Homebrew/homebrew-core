class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.22.2",
      revision: "5630b081cd25e4eccc7516a652ff956e51676794"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f2608db9217fb1be7c5655c143e168c93a7900bb3001dde9c010d6a509a92ee"
    sha256 cellar: :any,                 arm64_sequoia: "f2dc7dd6cef41f70d6c3dfa6fa1c6ad389bcb2b520e33b04b6584f31e60570e4"
    sha256 cellar: :any,                 arm64_sonoma:  "f84931d36b5ac7f7886ea7445e739d1f47f57d38a9aa252b50a5968f95f29e35"
    sha256 cellar: :any,                 sonoma:        "3cd8140298f1805652ff697c687bac97fe70cf42a80963f9cca6391fe6e89609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79923938f5a5540c0c4246d3532aa9fddd740ccb5b1d1e333790c932c6935c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832dd4b443be46d4f66e90c49bbbe7c3b7f8dadfe9c2a1ec8e33b527193733cd"
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
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  # Need newer than stable `eigen` after https://github.com/microsoft/onnxruntime/pull/21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  resource "eigen3" do
    url "https://gitlab.com/libeigen/eigen/-/archive/1d8b82b0740839c0de7f1242a3585e3390ff5f33/eigen-1d8b82b0740839c0de7f1242a3585e3390ff5f33.tar.bz2"
    version "1d8b82b0740839c0de7f1242a3585e3390ff5f33"
    sha256 "37c2385d5b18471d46ac8c971ce9cf6a5a25d30112f5e4a2761a18c968faa202"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^eigen;.*/eigen[._-](\h+)\.zip}i)
    end
  end

  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/8a1772a0c5c447df2d18edf33ec4603a8c9c04a6.tar.gz"
    version "8a1772a0c5c447df2d18edf33ec4603a8c9c04a6"
    sha256 "37bb2fd2d1e87102baea8d131a0c550c4ceff5a12fba61faeb1bff63868155f1"

    livecheck do
      url "https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^pytorch_cpuinfo;.*/(\h+)\.zip}i)
    end
  end

  # Workaround for Abseil >= 20250814.0 which removed absl::low_level_hash[^1].
  # Upstream only supports using vendored deps which we bypass.
  # [^1]: https://github.com/abseil/abseil-cpp/commit/2ea5334068f11664a71d1d9dfb9a475482fa05f5
  patch :DATA

  def install
    python3 = which("python3.13")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPython_EXECUTABLE=#{python3}
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

__END__
diff --git a/cmake/external/abseil-cpp.cmake b/cmake/external/abseil-cpp.cmake
index 427e77a524..feb2eb26f1 100644
--- a/cmake/external/abseil-cpp.cmake
+++ b/cmake/external/abseil-cpp.cmake
@@ -119,7 +119,6 @@ absl::absl_check
 absl::hash_function_defaults
 absl::function_ref
 absl::city
-absl::low_level_hash
 absl::fixed_array
 absl::variant
 absl::meta
