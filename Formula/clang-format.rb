class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-11.0.0.src.tar.xz"
    sha256 "913f68c898dfb4a03b397c5e11c6a2f39d0f22ed7665c9cefa87a34423a72469"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang-11.0.0.src.tar.xz"
      sha256 "0f96acace1e8326b39f220ba19e055ba99b0ab21c2475042dbc6a482649c5209"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/libcxx-11.0.0.src.tar.xz"
      sha256 "6c1ee6690122f2711a77bc19241834a9219dda5036e1597bfa397f341a9b8b7a"
    end

    resource "libcxxabi" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/libcxxabi-11.0.0.src.tar.xz"
      sha256 "58697d4427b7a854ec7529337477eb4fba16407222390ad81a40d125673e4c15"
    end
  end

  livecheck do
    url "https://github.com/llvm/llvm-project/releases/latest"
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "65667bcca091df96d9f27b56a7726a41c9998ebbcd3b10bc2eb2d43aa871c216" => :catalina
    sha256 "9b711f49db65634cb1dca8149804040f337ce3e68e66eeba7270c2aec66b90e0" => :mojave
    sha256 "9bbc58f9d5afb228c2aeda8ea03d305d7912860f27941933d0824bee505752bd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    if build.head?
      ln_s buildpath/"libcxx", buildpath/"llvm/projects/libcxx"
      ln_s buildpath/"libcxxabi", buildpath/"llvm/tools/libcxxabi"
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
    else
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"projects/libcxxabi").install resource("libcxxabi")
      (buildpath/"tools/clang").install resource("clang")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLLVM_EXTERNAL_PROJECTS=\"clang;libcxx;libcxxabi\""
      args << "-DLLVM_EXTERNAL_LIBCXX_SOURCE_DIR=\"#{(buildpath/"projects/libcxx")}\""
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install llvmpath/"build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir[llvmpath/"tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
