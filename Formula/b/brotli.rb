class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.1.0.tar.gz"
  sha256 "e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff"
  license "MIT"
  head "https://github.com/google/brotli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "64750425b7578860d8b6a75fdb187408667f7d6523169e8dc29528bbc15309f0"
    sha256 cellar: :any,                 arm64_sonoma:  "e75e7d3e86aba0f1a48f59bab9d819dbdd52c22259fb893ff1e796ca4dc9be75"
    sha256 cellar: :any,                 arm64_ventura: "531d7745ef045b6fe35a32f852d377a9bed6ea8a2c26828d8e18ce8388c1346e"
    sha256 cellar: :any,                 sonoma:        "8934e84777d1c6f63d6e4c07213731c9af1b7a66d5f0a6b3ef0bb6d56bb63a86"
    sha256 cellar: :any,                 ventura:       "59cbd7977b1e037c70d43e339dec2a8631d1360ceb4aa1f4a7780e2c4fef3540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72028690302ef20e9dcf10cd6405a8d8b736688ebd4ad7203078ee57be0f92fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1502cc6efe4e7b2835b1a8cb34536acee19d3c48ea3a440b57d88e5cab2ca81"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
