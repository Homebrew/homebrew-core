class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cf72bd59cac5ff31553c5d1626f130167d4f72eaabcffc27630dee2a95f4707e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32cb89d0fdd440a010257f06dd18ec57730ff49b4c20193597eefb7628a35b88"
    sha256 cellar: :any,                 arm64_ventura:  "cfedb352f640eaded3ac8cb622dfaf9a1cf63933125ee1db319ed9281521e4b7"
    sha256 cellar: :any,                 arm64_monterey: "b38e431229881c9ef9b47dddab0d0d932bd2fe490164c1c1b41ae2cfe5bda36b"
    sha256 cellar: :any,                 arm64_big_sur:  "20b28aaadfcdfda87a06b97c05d289f7bc13bb426db31feeda51e08d334ed5f9"
    sha256 cellar: :any,                 sonoma:         "f0b8a800d00b6e8a0c21824ff5219e571cd63a2fa8fe0a95a1929d0010e281f7"
    sha256 cellar: :any,                 ventura:        "ffe767563ae50907c5d6ba8c86fd14ba1b87a7ea03ce6023080e6192be6d1d13"
    sha256 cellar: :any,                 monterey:       "7a6a681b722e37ad1bb681607da6f5adfa65227aaa1508f1d2aaaab5a77d6d5b"
    sha256 cellar: :any,                 big_sur:        "86c3582d9571540c9346ae1bdd2d39d55a10e6bc58fd378db7f693df38e45860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "259c339b9bb745362a65f25e688a73336edfad5736c4228244a1e5bb89764a97"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@16"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_predicate testpath/"qsort.c", :exist?
  end
end
