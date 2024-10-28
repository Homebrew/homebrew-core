class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_120_b.tar.gz"
  version "120_b"
  sha256 "7202442f61d1d29b0cd4693ef210e83b61c7b83d9140c3100f040ac3a82484db"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29292c794cf605e525b06a61f25d9a5a9d69556979d1fa19c80973295835d429"
    sha256 cellar: :any,                 arm64_sonoma:  "25e06480f6181a7fff1409722c135ec9de1be390db038009ac943ac931b44805"
    sha256 cellar: :any,                 arm64_ventura: "410fa871c22b506786d3fda29dd4c86d433bfc6888259a3903d35b7a5674fab3"
    sha256 cellar: :any,                 sonoma:        "64eb05c655b941331080d4c4bd08190bc8424b27e2bac10b409a2bd23eeea14f"
    sha256 cellar: :any,                 ventura:       "accff12f49d550c72f3442b66404e4f278e5e83c9cb110ece59b49f2ba9f931b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00a4928f8908734c9779d9eed228bf2cbb19dd8dffff41fa4c77d58910df1a0"
  end

  depends_on "cmake" => :build
  depends_on macos: :mojave # needs std::variant

  fails_with :gcc do
    version "6"
    cause "needs std::variant"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTS=false"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end
