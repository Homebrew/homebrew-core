class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "a8fb27bae6403872bb6e5bb8672e79a5b7eb6b3d8fd7c3e6aa7b888436b68ee2"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "371508f0bc7b40459d4e94adbc898b4a51b826d2a47548161802409eec3d914e"
    sha256 cellar: :any, arm64_sequoia: "8a259e4280cbf629ab40490ca3e3f5c53560051bbe6f6807dba188cd7c0a54a9"
    sha256 cellar: :any, arm64_sonoma:  "47c49583b60cdd5f443806b8e8bcb4592195c639fe2e84ef7f020a4d96ec9f52"
    sha256 cellar: :any, sonoma:        "f785ffe8b6c3321ec10ebf2e5d2b46cac1ed23ae560058bf17a5cf0d43d55d5b"
    sha256 cellar: :any, arm64_linux:   "e6789fc8ebb11760c07f375f7646b6cf417aa6c7cfebf07020db5955242c88fa"
    sha256 cellar: :any, x86_64_linux:  "5d94c2f8f90ad0c4f3a6b82c0fb69705b4744859e61431129c74fab284d528e8"
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
