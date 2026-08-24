class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_132.tar.gz"
  sha256 "ede5e20f2f5148641bad31ceaef3c1fd4de4fb63b2d7b5081c605ba475483f6b"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8fa307a56219d5020e0121442027d4d1830a140fa5b3df01871f19522bea5c61"
    sha256 cellar: :any, arm64_sequoia: "5396f0b840a9a596a83ddfee9fe292dd8e4462f75139759b9334c6df5a55fe15"
    sha256 cellar: :any, arm64_sonoma:  "b615593153dc386584f60cddb59f57bff8b2afd9bc50ea5dba7a9a40541d4178"
    sha256 cellar: :any, sonoma:        "6a235ff87bd895ef5d39b82b63c84879d3a98e640f2d29e6281e6a97dfd8311e"
    sha256 cellar: :any, arm64_linux:   "8d201c5cc262c946c237c5e326d2c3ea334c8d590ad4e4e7816524d437df7ce4"
    sha256 cellar: :any, x86_64_linux:  "a38a54e6d7321a7af8fa4109ff59874add0efc9e0d0fcc9124eefb2f828299c2"
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
