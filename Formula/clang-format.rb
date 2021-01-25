class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-11.0.1.src.tar.xz"
    sha256 "ccd87c254b6aebc5077e4e6977d08d4be888e7eb672c6630a26a15d58b59b528"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/clang-11.0.1.src.tar.xz"
      sha256 "73f572c2eefc5a155e01bcd84815751d722a4d3925f53c144acfb93eeb274b4d"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/libcxx-11.0.1.src.tar.xz"
      sha256 "9fd5f669621ffea88a2b93e3d99f3a958b5defb954f71bf754709b63275f5e3d"
    end

    resource "libcxxabi" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/libcxxabi-11.0.1.src.tar.xz"
      sha256 "4a697056a5c08621a8380dcaf3836525835aa76b3008d9e8f27abf9270bf683f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "210043c597e9bde9a3f0237c1c31a8ef7da945594bbe9ae19dd1dd3775188ca4" => :big_sur
    sha256 "a083e51ce20a166020467d8f706dcb5de057df3a597c75e73fe10d5036ad2cce" => :arm64_big_sur
    sha256 "c43220c14172612d612f7d04df938b9ad646fdb29531c48cf4fc5a2ad17a196f" => :catalina
    sha256 "8db2426af381b430422595e1841dd9d134f37ab8551a1ffbc6025bf2cd852f96" => :mojave
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
