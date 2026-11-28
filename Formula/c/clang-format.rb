class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.6/llvm-project-23.1.6.src.tar.xz"
  sha256 "d3b86ab29cfb4445a6652e5c2642ccc75e04e38084dde3701d323320f35a31da"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d8924922bfa312d2f794a4781be33cdd2faed5710b08842301c6085ed7070a22"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "baa15b07d4ea97e5da1be32d89534a991d012702b9e8c26be152f87a9d2740c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afa67ee29cae66c5c99adce1187373bd2bed1b06768a8505c2771de4fba855fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e3abbadb2f094f0cddc46aa35063ab94c04720afb42e1f42888aa42e922b64e"
    sha256 cellar: :any,                 arm64_linux:       "c11e6e655993040452a270a235296582e6ba5dc89595e144b72e27943d0dee1e"
    sha256 cellar: :any,                 x86_64_linux:      "469639c0d0b846b5ecdbebe206637842a10befd0ec5945942acc46c3a62dae4d"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  deny_network_access!

  def install
    system "cmake", "-S", "llvm", "-B", "build",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"
    system "cmake", "--install", "build", "--component", "clang-format"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal <<~C, shell_output("#{bin}/clang-format -style=Google test.c")
      int main(char* args) { printf("hello"); }
    C

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
