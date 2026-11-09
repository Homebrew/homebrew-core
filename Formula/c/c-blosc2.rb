class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "3a80cd53c6963f74cc9bebbc2ce8607d65448cfdc277953e4201444574694687"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cff1b0488c7cfbcd3d5ea12f097f3a33f77bda3eeef53423b0d5d150b4720032"
    sha256 cellar: :any, arm64_tahoe:       "aa9e18e24137c7ffbf617b8cb2fc967e3eb494b35ebae835b093fbbfcf475b6f"
    sha256 cellar: :any, arm64_sequoia:     "d87d4654c8a0bd037f0b91aeae61359908307a626d26aa3671c1917805391777"
    sha256 cellar: :any, arm64_linux:       "e3a41baae82e44521b9f7589337e18cf2879c661f0c307352c192045d4237fbd"
    sha256 cellar: :any, x86_64_linux:      "2ebd92cc41a618d298f2e9dd9ee0b571289b284f719c1975cd55848a213e5503"
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
