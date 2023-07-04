class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.6.tar.gz"
  sha256 "bc4b07dc9c23f0cca43b1f5c889f08a59c8f2515836b03d4cc7e0f8f2c879234"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae508279c87f054125c885872d627e13a7b6083c269d131dec0def391eff4686"
    sha256 cellar: :any,                 arm64_monterey: "6e215c0a6d9cb81d4d339ea5c57fd27d4a39f790de2e0ffe341eb6e2d69ee891"
    sha256 cellar: :any,                 arm64_big_sur:  "62b004454894a463eaeeef80eb98d84fe4666436603a93aa861db0ea6a2a0560"
    sha256 cellar: :any,                 ventura:        "75d89fc6a54d5bc9630a3d1fc233339bdac651821e61ff26d593fc00f3dc6f47"
    sha256 cellar: :any,                 monterey:       "01fb909c89e532424ccf58da97527158378aa336b861cc98a202cc4473424b6d"
    sha256 cellar: :any,                 big_sur:        "a3461a940aa7e96b8d8426c08f5492bef461a9b950061202468d4ddad31b11c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df2bc2c0bba929262d933c093a7fa0cf12b624505dcd41efae42339d08d59a4"
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

  # Also, fix use of StringPiece for new re2.
  # https://github.com/google/or-tools/pull/3840
  patch do
    url "https://github.com/google/or-tools/commit/8844e557bfc36c1b171b84048a5c40b6dbc97206.patch?full_index=1"
    sha256 "c884d9d011548e28b503a424ac1d2be8197b0090d3f473708f3330b319130da0"
  end

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
