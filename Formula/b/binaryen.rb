class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_116.tar.gz"
  sha256 "049fa39dedac7fbdba661be77d719223807ba0670f5da79e75aa85d88fedc8a9"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "316d0953d1d243cab8f0b81a704ad59c95096a684a5758a7176c257b0865c72f"
    sha256 cellar: :any,                 arm64_monterey: "a6ff30826feecfca8dbf28585c28968c45c3907e744c511792565e6aca6809ba"
    sha256 cellar: :any,                 arm64_big_sur:  "267f232cda9528c7847f19d5257f5c6b44c220d84a64fd708d9da12f32c2da92"
    sha256 cellar: :any,                 ventura:        "d56f8b9fe9521bd80d994b18bcca15fdf48c9fa23ff709e7e08e581888651962"
    sha256 cellar: :any,                 monterey:       "6b7a692150e73868daf7679375c9a85cd452ef69fd0dd9e3f21dadcf4c922aa3"
    sha256 cellar: :any,                 big_sur:        "492271d95cb401c751e0b360d9c4e83c308f1029b2cec44498cef3934154f6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a313b589dc72fbb54f0e84515b8a679bb697fed846cdd3531fff6263d9cd89d5"
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
