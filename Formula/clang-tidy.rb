class ClangTidy < Formula
  desc "Linting tools for C/C++ based on clang"
  homepage "https://clang.llvm.org/extra/clang-tidy/"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-10.0.1.src.tar.xz"
    sha256 "c5d8e30b57cbded7128d78e5e8dad811bff97a8d471896812f57fa99ee82cdf3"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/clang-10.0.1.src.tar.xz"
      sha256 "f99afc382b88e622c689b6d96cadfa6241ef55dca90e87fc170352e12ddb2b24"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/libcxx-10.0.1.src.tar.xz"
      sha256 "def674535f22f83131353b3c382ccebfef4ba6a35c488bdb76f10b68b25be86c"
    end

    resource "clang-tools-extra" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/clang-tools-extra-10.0.1.src.tar.xz"
      sha256 "d093782bcfcd0c3f496b67a5c2c997ab4b85816b62a7dd5b27026634ccf5c11a"
    end
  end

  livecheck do
    url "https://github.com/llvm/llvm-project/releases/latest"
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    if build.head?
      ln_s buildpath/"libcxx", buildpath/"llvm/projects/libcxx"
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
      ln_s buildpath/"clang-tools-extra", buildpath/"llvm/tools/clang/tools/extra"
    else
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"tools/clang").install resource("clang")
      (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON -DLLVM_ENABLE_PROJECTS=\"clang;clang-tools-extra\""
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-tidy"
    end

    bin.install llvmpath/"build/bin/clang-tidy"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { printf("hello"); }
    EOS

    assert_match "clang-diagnostic-implicit-function-declaration",
        shell_output("#{bin}/clang-tidy test.c")
  end
end
