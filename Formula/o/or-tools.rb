class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.7.tar.gz"
  sha256 "054d9517fc6c83f15150c93ef1c2c674ffd7d4a0d1fdc78f6ef8bc3e25c2e339"
  license "Apache-2.0"
  revision 4
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25cead7bc22693406222e361949769e509f5ae55cac37c61cc49884a09c0ac97"
    sha256 cellar: :any,                 arm64_ventura:  "de80e7cb943246e4202b2d57624715dffaaee14432cf98638d75d2c20d68ba98"
    sha256 cellar: :any,                 arm64_monterey: "f83efe4f58984b3de57b78cc85dfa54a0edc481c105947794ae8a26237ec207c"
    sha256 cellar: :any,                 sonoma:         "f0220a1934ed533aec309f1a5f83c0d33eb8a05c8d8b2d46363d2a98c4d1f966"
    sha256 cellar: :any,                 ventura:        "bd2d99d46de42d438fcb5ee2b4c7764ca3fa37716e4e44c5357a571a1c877ad5"
    sha256 cellar: :any,                 monterey:       "135d7551b590526f0edbfe944aec606f6065df780ff3b48c1fcb7afc3bbc8fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472a2c36a88923235e4533b98813a3e59aec42bf7844ed459fdcfe480d6d7ec9"
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

  # Fix build with abseil 20230802. Remove when included in a stable release.
  # (It suffices to look for commit 734df45, the last of the three below.)
  patch do
    url "https://github.com/google/or-tools/commit/bb7c013bf8a4f1217ef3feb8f9670e6057b43aff.patch?full_index=1"
    sha256 "ac2618ed0a4106ea0af37ea7fc91e34c2f93c2e17c264d9df31b5867ce302745"
  end
  patch do
    url "https://github.com/google/or-tools/commit/aaf306ca38a4d634113d25a31ae7a558f824cab0.patch?full_index=1"
    sha256 "e2f3cb11a9db4dc53e3452ae28dcd2160ca86886385acb0a9c3076b179a39e88"
  end
  patch do
    url "https://github.com/google/or-tools/commit/734df45de4cf8c1a59b3fef972182dd0b48ef3e2.patch?full_index=1"
    sha256 "9bffe6f80ef61da0591ec9970751a90cff5c023089d6bd6331686d8e5d3e87a1"
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
