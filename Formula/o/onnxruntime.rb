class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.20.1",
      revision: "5c1b7ccbff7e5141c1da7a9d963d660e5741c319"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aec466ff3c136af218a5c53ddedcdf755a5affb8ea3e4a45a08ece660f997d16"
    sha256 cellar: :any,                 arm64_sonoma:  "2eca70956aa47707dd4799edcd11bcdff642ddf55e9834b7e5f85986e595b2ea"
    sha256 cellar: :any,                 arm64_ventura: "c93749fcaeecf6b64e8651de30352acd7d14f1926074a9186f2cf8be13dc82a0"
    sha256 cellar: :any,                 sonoma:        "975557a04b1d91a9c335adae9c93e643b8987a1bd0cfdefdf340bdbaba16bbce"
    sha256 cellar: :any,                 ventura:       "f8a9326453bff294371955a114734b6c465d4d55aa2af725a3b5ff6532d77fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c511a8d9e2967f6ef52b22bf88c83ccf42371716a5b2c3768bbfb536bd89ae"
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
  resource "eigen" do
    url "https://gitlab.com/libeigen/eigen/-/archive/e7248b26a1ed53fa030c5c459f7ea095dfd276ac/eigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.tar.bz2"
    sha256 "a3f1724de1dc7e7f74fbcc206ffcaeba27fd89b37dc71f9c31e505634d0c1634"
  end

  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L52
  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/ca678952a9a8eaa6de112d154e8e104b22f9ab3f.tar.gz"
    sha256 "c8f43b307fa7d911d88fec05448161eb1949c3fc0cb62f3a7a2c61928cdf2e9b"
  end

  # Backport fix for build on Linux
  patch do
    url "https://github.com/microsoft/onnxruntime/commit/4d614e15bd9e6949bc3066754791da403e00d66c.patch?full_index=1"
    sha256 "76f9920e591bc52ea80f661fa0b5b15479960004f1be103467b219e55c73a8cc"
  end

  # Workaround for Protobuf 26+ where RepeatedPtrField::ReleaseCleared() was removed.
  # Needed to avoid mixing Protobuf versions in dependency tree which can cause issues.
  # The patch can cause higher memory usage as the memory won't be freed right away,
  # but shouldn't impact functionality.
  #
  # Issue ref: https://github.com/microsoft/onnxruntime/issues/21308
  patch :DATA

  def install
    python3 = which("python3.13")

    # Workaround to use brew `nsync`. Remove in future release with
    # https://github.com/microsoft/onnxruntime/commit/88676e62b966add2cc144a4e7d8ae1dbda1148e8
    inreplace "cmake/external/onnxruntime_external_deps.cmake" do |s|
      s.gsub!(/ NAMES nsync unofficial-nsync$/, " NAMES nsync_cpp")
      s.gsub!(/\bunofficial::nsync::nsync_cpp\b/, "nsync_cpp")
    end

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

__END__
diff --git a/onnxruntime/core/graph/graph.cc b/onnxruntime/core/graph/graph.cc
index e8a5855b36..f5fab08720 100644
--- a/onnxruntime/core/graph/graph.cc
+++ b/onnxruntime/core/graph/graph.cc
@@ -1287,9 +1287,6 @@ Graph::Graph(const Model& owning_model,
     // Remove sparse_initializers from protobuf to save memory as they are converted to dense now
     graph_proto_->mutable_sparse_initializer()->Clear();
     const int sparse_num_cleared = graph_proto_->sparse_initializer().ClearedCount();
-    for (int i = 0; i < sparse_num_cleared; ++i) {
-      delete graph_proto_->mutable_sparse_initializer()->ReleaseCleared();
-    }
   }
 #endif
 
@@ -3639,9 +3636,6 @@ void Graph::CleanAllInitializedTensors() noexcept {
   // memory.
   graph_proto_->mutable_initializer()->Clear();
   const int num_cleared = graph_proto_->initializer().ClearedCount();
-  for (int i = 0; i < num_cleared; i++) {
-    delete graph_proto_->mutable_initializer()->ReleaseCleared();
-  }
 }
 
 const ONNX_NAMESPACE::TensorProto* Graph::GetConstantInitializer(const std::string& initializer_name,
