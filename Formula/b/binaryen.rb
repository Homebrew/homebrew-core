class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_117.tar.gz"
  sha256 "9acf7cc5be94bcd16bebfb93a1f5ac6be10e0995a33e1981dd7c404dafe83387"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b9d1efae45745462c3b1d1576300c0c226d6ba4e9e530eb4f43907cea80697a"
    sha256 cellar: :any,                 arm64_ventura:  "73c776a198a4d13eb6f0d4e3ff9a3b5cc32fc46a2971e9c0fcdc38d23de75197"
    sha256 cellar: :any,                 arm64_monterey: "e307eb50a285c5ee8b4dab869754e58cc1d3ac35086c57c9afaeeb68828f1130"
    sha256 cellar: :any,                 sonoma:         "96deaabc7c0678f1e88c482cd458833e544ac76619cd488418752e6cc0c534dd"
    sha256 cellar: :any,                 ventura:        "4580d4dc853e5bdc39242cae2ee0af21de41cbfe1e600d05411c9e2a63ff1e22"
    sha256 cellar: :any,                 monterey:       "972d5a3000c367dff7f3180881a6b9d33d03d9aa3db132be1dfe1adc3cc859de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb14806438269ece7de944f6bac822ecca2862b2402302c79eeeba946f87df4"
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
