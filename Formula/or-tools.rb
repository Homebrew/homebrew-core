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
    sha256 cellar: :any,                 arm64_monterey: "64c2b3a6438460e17d56d3d78e567ef0e293ef5ec911a335c6f13d47a7d95073"
    sha256 cellar: :any,                 arm64_big_sur:  "311a532e8b53e98c3e61d1d544c1f6cf04cd151b3e76e5b47e7ef3448e1ce77b"
    sha256 cellar: :any,                 monterey:       "ec2a0fe33bb8b859f910efee4c4f74a936ecff27e715275cf081c215107f7015"
    sha256 cellar: :any,                 big_sur:        "fc541facffb873535919dd270960ea045cc3ca005b3ef7b964b89bf1f37632d6"
    sha256 cellar: :any,                 catalina:       "f7bd6fb05b39983c5dcbc7f25f2bfd140d6c43d3832f76675cea2ed3a0f8055b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ef7af2c61144bf1d8c658a9cef4b2e9355a8907889c395e34a71250b0d5216"
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
