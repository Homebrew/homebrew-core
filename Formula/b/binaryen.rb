class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_133.tar.gz"
  sha256 "2f3e3d9edc56751499571da073a8a81943ca3fcbc08a945d2c619a7a1d4eb88b"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d98332fb7205da8d5f51cd41bad8b3c5390ced0aec627a49b63f6add4f54b711"
    sha256 cellar: :any, arm64_tahoe:       "22c610b253130cd20d22055ed8af19b919683ae2a337b6a14010f8a2abe295e1"
    sha256 cellar: :any, arm64_sequoia:     "2258f7ce1551dfaeb292ac27dce0340d07be96d66b6fe7eb0708194c923a4b7f"
    sha256 cellar: :any, arm64_linux:       "faf309f60e3dd21428407fa26962b45ea726811003569367b11bc6cc9995f2a3"
    sha256 cellar: :any, x86_64_linux:      "af2f77531dbf1624763c2e35ba9a0a5a07416c2fba1dc46bf10b14e6e8bccd25"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end
