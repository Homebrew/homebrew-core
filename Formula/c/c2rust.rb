class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a8fa6a88a5f40f35b1e63c086e981e8e03e0b887b769ddcd07ba46b0304c931b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df88c851f1831af9a3e630295ffa9e798d2c0ab97b9b8cf6c24e7b35ee432aa3"
    sha256 cellar: :any,                 arm64_sequoia: "d76ce3419a9d46b791fb45641caa5b57c214d622095a05518a491f42c0750581"
    sha256 cellar: :any,                 arm64_sonoma:  "ad5c82acd8ea345d143ceb5fd461f276b26626461b549318c2af9cc422acebdd"
    sha256 cellar: :any,                 sonoma:        "c542f2ebe2d58181c143b71a6931fc143dd861792db988a6c5c446158b36e6a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9274c9595424047d95fae4ebba0178c55f427612cdd9fc93863a8d91189e83f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e5ca318401131f2e847996218bcbf7e2797f7e4c5cf893233bdfd8772750fe"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@21"

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
