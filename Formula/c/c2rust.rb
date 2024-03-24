class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cf72bd59cac5ff31553c5d1626f130167d4f72eaabcffc27630dee2a95f4707e"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6468964b49221ea68654b1b20614ee165bd6bc7813ed3a3ac83a408b61acadbc"
    sha256 cellar: :any,                 arm64_ventura:  "4b881c0a268297ab0e72383634dfa31d10d1d4bcf0112490e256f33b04def8f2"
    sha256 cellar: :any,                 arm64_monterey: "24a291afb771e6b0e3acbc306b58c026aa6638553a88cc32d07f1ef2076441c5"
    sha256 cellar: :any,                 sonoma:         "885c7ca1fa588808fbac2c201a6a9d69fea4ffc13b4c80a23d40655625598c3e"
    sha256 cellar: :any,                 ventura:        "f3b5c3993177dfab51701fe9167d7d0f1e68dda66014c2a3ff7b03239861c2b9"
    sha256 cellar: :any,                 monterey:       "13e5b15f1104f76498a92181376d028b00f14f36ec8bca05ff43227125709c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff449be9f5c9429f4c93de68eeb7bbcfc74b8ba0c0fd608b48a45cacc0798cf0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  # Support LLVM 17, remove in next release
  patch do
    url "https://github.com/immunant/c2rust/commit/df42b55eae9ecfd4380004a513a10526ef8776cf.patch?full_index=1"
    sha256 "0bef002335192076888c236faec2edcd8cb6fb3ffd6e38994fdd7c70d19089a6"
  end

  # Support LLVM 18
  patch do
    url "https://github.com/immunant/c2rust/commit/3e09934e91613c246393bfeb0d5bbb386ae0e16a.patch?full_index=1"
    sha256 "05b895bd49174e5e7c7a893ef7f80710ce804a6c42fc0ea398cd46ab0fa5f068"
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
    assert_predicate testpath/"qsort.c", :exist?
  end
end
