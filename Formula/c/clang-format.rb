class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.3/llvm-project-22.1.3.src.tar.xz"
  sha256 "2488c33a959eafba1c44f253e5bbe7ac958eb53fa626298a3a5f4b87373767cd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3613e36164e37b69f2f057417db9311dbed722499e5d24cf999696cb83e94156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78ad3bb0547b6a67d02831827ac026adbf7c7961960f3058c29766772d50ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6aefa8f1280e6a7915d17ca8af523ef1a7e48240904681e3952bdbbb6853b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "9262a531f8f9d220793bd3ff9a7be83067e8801faad419452657e81a95345557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0c379da191d806302b401569d1c43af42cf6580b8496e7b3f86ad7a4347244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415c7ef2ec812524ff85a32b464a201216514596783b9389b6abc415ed56e323"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

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
