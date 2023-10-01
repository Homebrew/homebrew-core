class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.7.tar.gz"
  sha256 "054d9517fc6c83f15150c93ef1c2c674ffd7d4a0d1fdc78f6ef8bc3e25c2e339"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20d80244fab7bc89025c0597a63356efd30cd140e5a9997ccdb6f8e1c3428111"
    sha256 cellar: :any,                 arm64_monterey: "2aef42a9b14c6b502e6de7cdd47717f063dbb491733b07551819c6f8a1efcf7a"
    sha256 cellar: :any,                 arm64_big_sur:  "814a1d0744c97fa4567948eb397f3d0d73fb0dd1b5069e86400fa6f885ca8ea7"
    sha256 cellar: :any,                 ventura:        "53a1057bf1ac144ed781341b82bf46753fb53246179d2b4b92f448f4716aee4e"
    sha256 cellar: :any,                 monterey:       "d03bc7801c4c266a6a9c225606fb906a39ef4e59925946cfaa91db3cf30d23fa"
    sha256 cellar: :any,                 big_sur:        "5d9a84f593137bf444cace94c2d1689015b76e185a780ab731723970d91250d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77726d8df7c553b897b7e4f4f250529aae5b0528ab25d7a582c91dc374a90670"
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
