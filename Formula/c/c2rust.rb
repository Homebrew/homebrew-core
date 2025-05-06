class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "482330d3f27cfe85deea207e490bebbbe9c709b4bc054e3135498b3bbb585bec"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "905499716b48b54ad1eea09ff40e229e2056536e72098b7605dc2ddb145117c4"
    sha256 cellar: :any,                 arm64_sonoma:  "7ad4256baed5d1869cce80b57a863c9ef20c7b73632b574a8b4d40d35f4c6fd4"
    sha256 cellar: :any,                 arm64_ventura: "60df9dd74e927f4dcbd82409a1e09036602b5de922e53b1cf8377cf6b199d069"
    sha256 cellar: :any,                 sonoma:        "8575b649a3f0faa7ee46b1f1bc38435f284973ef02b8ad24afcea5477eb60e40"
    sha256 cellar: :any,                 ventura:       "dd757588e38c35414c4a47feb0d0b40b2aeb39bd4f94f001c2479253fd433ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20c31538b457c35efdf00988833dcd68df79d82e6ddabe188fe479b1f4fc2376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8150aa61370a613f5df88413c96cafc937fe817e0f80cff2134132270323feb7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@19"

  # cmake 4.0 build patch, upstream pr ref, https://github.com/immunant/c2rust/pull/1214
  patch do
    url "https://github.com/immunant/c2rust/commit/c96c1c0e49d8be452d97b3e13c741324befd7b77.patch?full_index=1"
    sha256 "9670a043ffade24eb014e6fee69707ab69df81ea76f9973fd7d4a68499362013"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_path_exists testpath/"qsort.c"
  end
end
