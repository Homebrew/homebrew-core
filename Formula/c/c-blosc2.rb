class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "25b9a789c48db610a5e033cfeeded55be21ddc988d33657d1057f0014149228e"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8bd1e88bd215225b6e808a8ffd3ff87245132d5a9f5570808ceee2d52bc86cf3"
    sha256 cellar: :any, arm64_tahoe:       "4c055351b7613cdc2b65fcdc8b7613e8f475d1eea57a6c601cfbf9fe04f49933"
    sha256 cellar: :any, arm64_sequoia:     "c653afc9c2cdbb5cf92516fcf65e3c5431ffe378553869628e7491b5d63eb58a"
    sha256 cellar: :any, arm64_linux:       "248792bc949bdcd468519655355b66578f759f4c7abb0caf90d2a30255cb58ca"
    sha256 cellar: :any, x86_64_linux:      "cdba64bb5f561dbad9c785ab7aaff5adeb6adb173a7f158528fe16626300b9a2"
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
