class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  stable do
    url "https://github.com/google/or-tools/archive/v9.3.tar.gz"
    sha256 "6fe981326563136fbb7a697547dc0fe6495914b5b42df559c2d88b35f6bcc661"

    # Allow building with `re2` formula rather than bundled & patched copy.
    # TODO: remove in the next release
    patch do
      url "https://github.com/google/or-tools/commit/0d3572bda874ce30b35af161a713ecd1793cd296.patch?full_index=1"
      sha256 "b15dcbaf130ce1e6f51dccfd2e97e92ad43694e3019d2179a9c1765909b7ffb8"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0faf1b3fba7782db8b1e708364b8ae287dbf2e67ddfe7bab55def4b0d48fa693"
    sha256 cellar: :any,                 arm64_big_sur:  "506e6cb475fc961d672c938b2b1781acbc4f8e2fa51308768f9dadd28dba044f"
    sha256 cellar: :any,                 monterey:       "80911815e041760b9f153fce5c70679d2f7a4619829611b1bd46185604b98e0d"
    sha256 cellar: :any,                 big_sur:        "d51a27bc90f3785fb7d7eed73d33d041d875c735c6ef160a1ba438dfba5cd4cc"
    sha256 cellar: :any,                 catalina:       "587a625da338cdb668c0a3187c1bbd8a48b8085d84efaaef0f165f63cdce4963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "869eb8cf6a02fa6a9514b9a656a040f79f0f342b3d68d72ce2c17b7340e10306"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DUSE_SCIP=OFF",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_time",
           pkgshare/"simple_lp_program.cc", "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_routing_program.cc", "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_raw_hash_set",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
