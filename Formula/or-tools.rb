class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.6.tar.gz"
  sha256 "bc4b07dc9c23f0cca43b1f5c889f08a59c8f2515836b03d4cc7e0f8f2c879234"
  license "Apache-2.0"
  revision 2
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c38f6d8ab5b99e81909295316cf3d17e586ebcbc2adc775b048f83f8065d1a8b"
    sha256 cellar: :any,                 arm64_monterey: "b4eabd71515566ca3647c508f019ae60cb4ec4b61dbcceb2b86498729838367a"
    sha256 cellar: :any,                 arm64_big_sur:  "9d8e3402c72eacb9391f085213116975d1d66932319fc3835e05a0d1b49fc004"
    sha256 cellar: :any,                 ventura:        "67867a210ee11f1764319bb142cd0887d0d0e0b9986a8ab730ca51c81c4b1f00"
    sha256 cellar: :any,                 monterey:       "c3bd48d08052e7f9f26a076ab0232bf91c78b41399e4d341ec023c474a45ae20"
    sha256 cellar: :any,                 big_sur:        "c95cd68dd9fa3b2a62fbe59adea564dfd0695fad0668323339dc8663db4a01bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b05c8f4bfe99c64a8ffe30561ec76e726f08db62879a1920fce9a7c0646d37d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Fix definition duplicated from Protobuf.
  # https://github.com/google/or-tools/issues/3826
  patch :DATA

  def install
    args = %w[
      -DUSE_SCIP=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end

__END__
diff --git a/ortools/base/logging.h b/ortools/base/logging.h
index 7f570f9..183b3a4 100644
--- a/ortools/base/logging.h
+++ b/ortools/base/logging.h
@@ -52,6 +52,7 @@ enum LogSeverity {
 };
 }  // namespace google
 
+#if GOOGLE_PROTOBUF_VERSION <= 3021012
 // Implementation of the `AbslStringify` interface. This adds `DebugString()`
 // to the sink. Do not rely on exact format.
 namespace google {
@@ -62,5 +63,6 @@ void AbslStringify(Sink& sink, const Message& msg) {
 }
 }  // namespace protobuf
 }  // namespace google
+#endif
 
 #endif  // OR_TOOLS_BASE_LOGGING_H_
