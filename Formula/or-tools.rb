class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"
  revision 3
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
    sha256 cellar: :any,                 arm64_monterey: "d989b8d2d8a497b6b19dc718600fb91240ca9d7ed9a7e0e698accf2bb568832d"
    sha256 cellar: :any,                 arm64_big_sur:  "0f7233d399ec76b558b2340ee3743d7b0498cffe0f1659927eb18615c0eeb01b"
    sha256 cellar: :any,                 monterey:       "079a215ee733d3ef428114772a4be663fae55ce239408878dfad21e350b79b77"
    sha256 cellar: :any,                 big_sur:        "07f35b9cfb0399a38239838abe5c4719fbd353d622af6a261a847e43fb6bb521"
    sha256 cellar: :any,                 catalina:       "791afd49675df591bfe10e2f994d07f29750cf5f20120addb26e320af9befc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c992b3f9b34d8f9dbc964bb1e77407b2afbb4c26730d29c7e9de40f0637e77bc"
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
