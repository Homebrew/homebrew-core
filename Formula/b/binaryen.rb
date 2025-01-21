class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_121.tar.gz"
  sha256 "93f3b3d62def4aee6d09b11e6de75b955d29bc37878117e4ed30c3057a2ca4b4"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd9de93a74b980cdd52ff316af71357e9c0431330a367366c44fecad0c662016"
    sha256 cellar: :any,                 arm64_sonoma:  "5b320f5944d7e5d1d9ba331a54867ca34186e75617756e617982671524ef85dd"
    sha256 cellar: :any,                 arm64_ventura: "2230ec3ab24197fb2ea483460f9ea9e4454bea70823e6b012dd7e8080d5cf1f1"
    sha256 cellar: :any,                 sonoma:        "b51ad87aa9815014c10d03e0f71f05ad994dd921d616a1640906a9cb93391e4d"
    sha256 cellar: :any,                 ventura:       "bf465f9ffebc2e6d550bc466256cd2639a3eddde35e6830df2f4edadd131f334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e0cc56b6117d0040efdb1aa0cab6a15a3bda5c3c991f00be2917298cc8598c"
  end

  depends_on "cmake" => :build

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
