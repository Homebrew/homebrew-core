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
    sha256 "4ea52df9cb0e800e8fe2f7a62b4c8b7424ae2d9eba162db16567c9488d6f0f38" => :catalina
    sha256 "4ede17c7d92cf28437513c553283a8916e50c4da976f7fef4e1036b3609917d4" => :mojave
    sha256 "59ebd49389d11862f756f02f7d4bc3aa8de109563a40eb9a8c469eb2ada625fb" => :high_sierra
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
      args << "-DLLVM_EXTERNAL_LIBCXX_SOURCE_DIR=\"#{buildpath/"projects/libcxx"}\""
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
