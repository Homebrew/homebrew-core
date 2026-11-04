class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "25b9a789c48db610a5e033cfeeded55be21ddc988d33657d1057f0014149228e"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "867cd2247e6fe488d7d6784c6b4f6867dc783edd7c2b8e77ee119fc70d3af32a"
    sha256 cellar: :any, arm64_tahoe:       "b7bd6bec57c72a5005fb4bf481ed58340852e07b23380a08be11538f36ad2d63"
    sha256 cellar: :any, arm64_sequoia:     "dd8ee4a2b2e57a0d794589d449d33714c9a72711e52695b660ee25b93a6fb97e"
    sha256 cellar: :any, arm64_linux:       "7a8c705c04f3e9fdc597fcb384dba67ca45ac8f42cff5a7b60927e6336af3f30"
    sha256 cellar: :any, x86_64_linux:      "8ec00bd702e21abd80850f8d596cb8c6bbd0a69be6dcf7c5161f398d3bb8bfa1"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end
