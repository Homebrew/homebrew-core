class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7a178ad0f858e6169aa5c0edc85e04c754b954de4d0c3336d90a98ec8f583512"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef0266ce3f58b3fcfb099460379718daaddda579cb6fe4276033ee53ce28fa14"
    sha256 cellar: :any,                 arm64_monterey: "f2418295fb1799248c0953bb50d10491d3d098c31589b9da90a0c4f4202c9989"
    sha256 cellar: :any,                 arm64_big_sur:  "91e780a79d0faad66081f2351dc51db52a8b53e5917d37582252d68539c7d4fa"
    sha256 cellar: :any,                 ventura:        "6ca3569f68c48a1934004e0d39f5876ca864af1b2b6dda0cf56dd72e23c2705b"
    sha256 cellar: :any,                 monterey:       "ac9149ad2d77b36a266309f65b688d8e0689b2d27722d9289756344a9fa87581"
    sha256 cellar: :any,                 big_sur:        "0ffa4bf5baa798997fd175325ebda6cc31955e69934241487976acb5b6cbbfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5993deacf7b350d6ed3673d76b91a9f6e3013bbd495b054f6f0f152f88ea7ac"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

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
