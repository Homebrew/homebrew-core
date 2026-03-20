class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_128.tar.gz"
  sha256 "56fd30ce083c5c64a22424e88b559397e208a55c7ac3d31ead2aa059214644e1"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba4801a20470fbf674f175f6d0758761c49c3784d295c5a19535ce083e438c76"
    sha256 cellar: :any,                 arm64_sequoia: "5f7db8534eb551c01a4711ae345cfb9df1d858f869096c33274274e79b5baf49"
    sha256 cellar: :any,                 arm64_sonoma:  "b54d27ea00a4e0faae8a228403b271619c27b357f541a5efbff862eefb7a3445"
    sha256 cellar: :any,                 sonoma:        "63385796a8d0c4b57d126bafaf34746d5918bf6d8d22ff63cf3ec8b3cf77754e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03365fce69fab535e91483bd4f677e735b0bb87e5a1b80ac9a01b43ee87f8516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5287131857d8f352aa22bc5c1b77bd62199ab5101998dc7ec35a47950ac9d240"
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
