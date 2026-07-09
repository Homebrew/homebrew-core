class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "6f84c35a7780ad6b58ee42cb823a25c99d2e1e3ae97533a6996f7d1869ed8ddb"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1db66844cde39498791992ccb264d85c3615d5696ee581b84466cb74fc91115"
    sha256 cellar: :any, arm64_sequoia: "63b64f517d2eead4f8a04d57b938be8171f67805e237f15f97a7dd88ec62431e"
    sha256 cellar: :any, arm64_sonoma:  "4210f73107a9bf6c531b34ecb2104d64ed7e16ef056851150f659d5cda078759"
    sha256 cellar: :any, sonoma:        "f45631377569cdc5ee8f56388fede1f9151d7cfdb7c3dd860754b89e26bef875"
    sha256 cellar: :any, arm64_linux:   "d6a1356682584d9b3aa2598626730d923a44271ee2b6868014b5007759343970"
    sha256 cellar: :any, x86_64_linux:  "42d081073b2a8ea25a4697b4e972033dc7bcb1fcd84b21f49e3b5085ceddfb15"
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
