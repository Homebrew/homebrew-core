class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.5/llvm-project-22.1.5.src.tar.xz"
  sha256 "7972b87b705a003ce70ab55f9f0fb495d156887cba0eb296d284731139118e2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f689660f3edb5047bd99096a50fde94b1edaf61e1e1fad8116353f809aeb54e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d153c48a88b8603262b9132c0b64ef81e74e79d8b494739ca72f39c492afae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212cb906d015621b9c44aaf2e7c035e310a9c3c31e1507e22d4226dea8c8a669"
    sha256 cellar: :any_skip_relocation, sonoma:        "387c94ba95b18268469eed83e9e35f9a5d22f6a0f0f664fa8142d55f35b4374f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587a998515eb9e0b8161f7ae4dc9e75b5f2cdbf68f9b9b0180b867e89d1188e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ad7db4210ca1fa12a5a997ea77ceb92fe72a68ee429d1cb1d7a3314b99e484"
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
