class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a8fa6a88a5f40f35b1e63c086e981e8e03e0b887b769ddcd07ba46b0304c931b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5ced02018ae3d0640b8551011f1088007e929a3e0415cee5be512b2e4c33a3c0"
    sha256 cellar: :any, arm64_tahoe:       "773ad17a6bd39b4207f6c55797968b2f4884a179282a4d15f5027482fce0bb04"
    sha256 cellar: :any, arm64_sequoia:     "debf7581eaf94a16143d6ef4e1b9c3261dcf59a9012193c89b89fc27c84dbe61"
    sha256 cellar: :any, arm64_linux:       "c74c38d5f9db674e4c3ffaffc073a6b38c2c16613b9e4552cc25607d196f9060"
    sha256 cellar: :any, x86_64_linux:      "bdd7f324d5befc96ed912afd2955263f2f7807946046d0238897e50d2d75a9e0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "tinycbor" => :build
  depends_on "llvm"

  # Allow to build c2rust using brewed tinycbor
  patch do
    url "https://raw.githubusercontent.com/immunant/c2rust/9199011134df8ba95a12b8703fe708a947f06c7f/nix-tinycbor-cmake.patch"
    sha256 "2ee5b463cee25893b274b59d555df524558a40be92a768caf63dd859e9615806"
    type :cherry_pick
  end

  # Backport to apply subsequent patch
  patch do
    url "https://github.com/immunant/c2rust/commit/50f5cb3cc6044591ddcb54aa343606c34c7edba8.patch?full_index=1"
    sha256 "89dbdca4a8db48eb6960db0fe066579a3c989c156270afcbb5e7b07bd1f24651"
    type :backport
  end

  # Backport to support LLVM 22+. Using local patch to remove test changes from commit:
  # https://github.com/immunant/c2rust/commit/756b1f9444719331aa69326c81b93ea0562add51.patch?full_index=1
  patch do
    file "Patches/c2rust/clang-22.patch"
    type :backport
    resolves "https://github.com/immunant/c2rust/pull/1671"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["TINYCBOR_DIR"] = formula_opt_prefix("tinycbor")

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
