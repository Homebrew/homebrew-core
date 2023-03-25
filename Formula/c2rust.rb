class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7a178ad0f858e6169aa5c0edc85e04c754b954de4d0c3336d90a98ec8f583512"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "46c07e6c24ff13a0a1296c80f20e3d1c44b19b95029ed9b538a9b69554c3e525"
    sha256 cellar: :any,                 arm64_monterey: "e0bd2e8a6d8bcbc4e0d8bea0c8d4674e4fc5eb5998a8a97cffb82d8cb0106594"
    sha256 cellar: :any,                 arm64_big_sur:  "d10d074a2e1379acec56e169d05c3792e3495749de6b261ef232d60c409d6842"
    sha256 cellar: :any,                 ventura:        "942f08195a3e4867b299dac5977a430b0cc46691470adb67555cf72ca564cf09"
    sha256 cellar: :any,                 monterey:       "8883927388f86cf067cc7554899334a4bdbae7390317d81e3cb1ba9dbd431243"
    sha256 cellar: :any,                 big_sur:        "2610850989d5233b3e6afdfda23ba9308cace598e78edd5ba7d77b9307aff8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8edc14b3220e57f45d22393a71f2578beade7da4e2af7bb1225fce0eadd9b97"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@15"

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
