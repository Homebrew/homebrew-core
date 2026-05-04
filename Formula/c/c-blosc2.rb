class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "c711e988ec25c0e05030d4db996a2e07bad3d07000c62844a4f45b2a9860a6f1"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7a695892623b0435381985cb5c0eefd4eeec767c0865b049ff3e9187c20e26d"
    sha256 cellar: :any,                 arm64_sequoia: "1e501ce1c0b2b7f23ffd7413ec0d097a34b6962127946ea29ca851217a8a7650"
    sha256 cellar: :any,                 arm64_sonoma:  "b3e94bb1a0cf7f988847704f29a896551116cf8161909775f2b0ae704769257c"
    sha256 cellar: :any,                 sonoma:        "1c274791fa4f0e810e6a958fae3890690e063ce36ab07837e0853d443eb048d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d19d5e19abac82ffc6d0e3565ddbfbc02daff47f9dccf7725a689633006f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a126f9856cff731db329db04b2c32fe9b5e5a739150ab7ae3eb6507d1527a43c"
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
