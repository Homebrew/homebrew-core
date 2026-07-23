class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_131.tar.gz"
  sha256 "3274719775038062b62d2bf2b37dcde69f3f79804aeb7420b78926722c0d0065"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0cfca31b9e2d19658aba138660dd48c469dc8b68de6bef662885c6f52b0e597c"
    sha256 cellar: :any, arm64_sequoia: "6ed0bd96acb0f4230df8d8ca22cdb1edce69537facd514fdab0b3e2fc6d357cb"
    sha256 cellar: :any, arm64_sonoma:  "71aebbbeba42e8499a4242a3b0910872f4e2f553e9e3d604ea65ffd78e5705f2"
    sha256 cellar: :any, sonoma:        "e70c5d30ef337ba8601475c1323aee81fac0f80a8a10703cad87d4c2ecbc321d"
    sha256 cellar: :any, arm64_linux:   "c44f726afa02b6b574779823d993cc94e038201a9e73530800eb7fab7e75a426"
    sha256 cellar: :any, x86_64_linux:  "e20c66a9b1a826a00155e8e051f9970ca54e3a0e72e6107dc110e2515cd82881"
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
