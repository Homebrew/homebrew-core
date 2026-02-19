class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_126.tar.gz"
  sha256 "f1c53762abae21cb6bc3e55d4e96d4ca4ea261f83a51d2aa47abc75d60e683e7"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc4ff4de16353ba9465745e79017a175990507c971ef2e1d0b612f65788d4272"
    sha256 cellar: :any,                 arm64_sequoia: "e71a86a37713bb073f9aafbddd0db162c105a0d7b33a025a5530fa2e17ddda31"
    sha256 cellar: :any,                 arm64_sonoma:  "6bea2bb3aa0a26342c6269dd24b3de84cd58ea471fc1aee7b9f8b022291e4180"
    sha256 cellar: :any,                 sonoma:        "616a029680d03297d63dc881d91b122bdb962ead7af799ce9e7094b03c989114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "766830896c9a5145349bc66f2a7e39ba9b91a58bf9cbd11b968089dcbc492e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc2c112e22a4f86ed776536fe3c83e68e184500ec465168141e19e0fe8cfad9c"
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
