class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "912c28e5e289d1a9ef1e0f6c89db97eba19eda58625ca8bdc5b513fdb3c19ba4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6eefd13cc36a0b3ab1cbfa9ec802bacd36ef00206ed3cf827c62f9c403c48676"
    sha256 cellar: :any,                 arm64_sonoma:  "069b88aa5e4065712b9dd17c778bcda625d3ed6c1f1a5e781238fed63bed1783"
    sha256 cellar: :any,                 arm64_ventura: "39fd69af63e922ea4238fd482f100abb7b16c4cd780f25405c85212542400fc1"
    sha256 cellar: :any,                 sonoma:        "d8142840f7b061e9a1fe8a7abc122a02241d085da8b9be1a2a37ee3f3bdcfe1b"
    sha256 cellar: :any,                 ventura:       "aa1fe9c8bab9e74dc4eb4a95587b26723eb37cdd9a409251073d3a55fa51a723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5016b79a5d6b22e582fd3ac7aaecf39bffa3677f3247408f725e77b42502bba"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

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
