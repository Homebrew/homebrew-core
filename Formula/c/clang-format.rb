class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.4/llvm-project-23.1.4.src.tar.xz"
  sha256 "819ecf7351f1a66f76b2d701d8942faaf5faeb324cb90c9d5b090de142434bb2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "297fda0ce67d8fae6d5899683473b1ee20f9261bff64dbd7438e5c3ba3272273"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abf401f7c78bdab515741a570300a1e291c45b018311debc4beabfaef0999de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa203ccae3f39c8de11cf312511d90fe30ee74f0709a3eb6a2f1fad0336cba8b"
    sha256 cellar: :any,                 arm64_linux:       "99bef3f563e9fe97a335afa3ccae1e8ed9948af296e28e6e82a987b813ecc9d0"
    sha256 cellar: :any,                 x86_64_linux:      "ff3707f2817a4dcc8b2a66ad27e4d8ffe812ef99d879d1ef88d3b284761e89e5"
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
