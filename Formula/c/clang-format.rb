class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/llvm-21.1.6.src.tar.xz"
    sha256 "908bce97be0275943414b45af2e2b20e8f6d5d9266fdc120bd59f096ebc547ad"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/clang-21.1.6.src.tar.xz"
      sha256 "348ace5d715c4caa6fb89b4c6fe07c21650e10b2fac37d8b0db75c0b11be9011"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/cmake-21.1.6.src.tar.xz"
      sha256 "e364f135fa14c343d70cac96f577f44e8e20bf026682f647f8c3c5687a0bebd1"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/third-party-21.1.6.src.tar.xz"
      sha256 "8d09dc219cdb3da7dafd2161836aacdd6e02c1a113498ab5f37688599406dc8a"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f8b18b779a15671462d9b835bc523e6a64fdb9813a083060b38f5cb77a13df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d70e77c435149351e73fb7893a2e6f12f890577b49ce3b403a912f6e27cc28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd85785f63bd9dc4ba66e782d40429ce9393b5860e3997575da6a7760588dba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad27531f1fd3911543eb467e42e29709a3819d13fa45e79d105c52cdf3723929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de3300f3fc872857c79a91b911a168cbc30cf9476778fe6dd242604b5a8b367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b4bd861aaa17da62a8d4e3854af74df27568b143ad3252495065d3ce71cc4d4"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
