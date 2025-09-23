class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_124.tar.gz"
  sha256 "b8d06af81a8c2bb27c34d1f9e3cf7c621f93fc901f896809e0490f3586a63ca4"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f165275861ffd59b001dbb7fd3768e65604c241772e5efb407fd808c9173dd2"
    sha256 cellar: :any,                 arm64_sequoia: "213bd9cb91194876d9848e8c9531610f4151ac9fc3bee3c6970a44dc1d0e4324"
    sha256 cellar: :any,                 arm64_sonoma:  "45b3c3fe30b13353c5e631a8da0398944980aab157556b0ab250f0161c917439"
    sha256 cellar: :any,                 arm64_ventura: "5d1b51d3306078a2da4f07b3d9a74298f9acc8acdd161dee5ac150c8afe6496b"
    sha256 cellar: :any,                 sonoma:        "61f4f1510e017592ea3dcbb794234bec3072c4626519239abe8184849facdf95"
    sha256 cellar: :any,                 ventura:       "313f17811f062fc12ab94d4f01ab7f21fabe8b2838166a5190fd7bbc42626428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ac1a9da19b782eb28ad60cc039d16d8ea019466d1b95d3f3ac1ba1ac849379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e948c1695635ca96ec9f31c00446594a6150cf8c0274c0192e08233de72269ce"
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
