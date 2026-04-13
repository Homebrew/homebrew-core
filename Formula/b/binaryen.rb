class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_129.tar.gz"
  sha256 "326f03e3a8b9eddc63cd9d6ff943bee86dae6f736c9f217e58530350381b011a"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62f236956783f0acb1846eabe1a74fdff6199fe39bcb1168dec4a183f7de0b02"
    sha256 cellar: :any,                 arm64_sequoia: "1b10ced6728968be30b291524fb53b55feaa411a49b95b1403d657e86405485f"
    sha256 cellar: :any,                 arm64_sonoma:  "665475a0a58387e3055e7a8441c5d4c2af861dcb1128671668bf5624781b8d39"
    sha256 cellar: :any,                 sonoma:        "b58c190f68b72e017bfa64a1c3f997e7b9385be986e3fa2a9b3cd451e9ce2501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0aa2afab9f0bd16a5fb44cdc03fdbfd6ba637e1da7978fde2511ef1a81331c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "060f1a6e3cfa3d8318782812eeb3bf107ce3598d738df87468fbe515f8026100"
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
