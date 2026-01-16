class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_125.tar.gz"
  sha256 "36177034ef0f0d826fd7dc9ab9d92ef20190a79d69856f764151ffe9c11d7350"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b517fd9435a51e97dabdcd8d61e9fbb657b06a3eba39e662ba26f11cd11e3916"
    sha256 cellar: :any,                 arm64_sequoia: "f08f11c275540d21d343dc727f0cf31732706ddc1201f1c53d0b6c1c28e8f71b"
    sha256 cellar: :any,                 arm64_sonoma:  "6d39c2f9a916b7a209ba116863ca46a555c4227c8404c0cbb7149d029416bcda"
    sha256 cellar: :any,                 sonoma:        "38883cf18c3aa17128aa969af37ae16eeb0798f29ac70b34ab8e2cbc252e67a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a019abadde60c46dfcc8d56e91440eff81c43f231f8e0c5e80f559512d6086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7cd86cd21c1674afedf1bfae2fcb4d01b3cf2307282678165fc40180d18af23"
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
