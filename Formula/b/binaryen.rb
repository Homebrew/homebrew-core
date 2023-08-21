class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_114.tar.gz"
  sha256 "54f794a843d96cc841bf8045a9dfeaad8161341f0b50ac5b197518c2d39482ce"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ece5930eb44576f995f9b30cf4d215c9ac18f933fb50152c283b7d9417de0210"
    sha256 cellar: :any,                 arm64_monterey: "81a41654e47c93cff4bab4fc1a3400392e1d0d9ab77af142231b0b55bfbc573c"
    sha256 cellar: :any,                 arm64_big_sur:  "9b61c3bf8bf6059563bac52545fe3d9a96ab3f8ed862ffbab74033ffa457c288"
    sha256 cellar: :any,                 ventura:        "c2d0b7561614f1ecc2599b97217b48ae378b2b21d82a7a287bf1f35de2cc9b8f"
    sha256 cellar: :any,                 monterey:       "d66d08ab550207b546682a24dda875db7cbd744205a2e8af12274f54e85756d1"
    sha256 cellar: :any,                 big_sur:        "c211791dd66b3042b53b94ee959ef94edefb9fd19351e997d98a832342a2e790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d054d8b3feb09c544b246fd5cb827629b561ea9c8fd2a54209dc82b4438fbc"
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
