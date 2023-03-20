class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-16.0.0.src.tar.xz"
    sha256 "bce6fc19c48501546097e7b839c9ee376ea23b5cfd09199de8e42d5a5b5d4aae"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/clang-16.0.0.src.tar.xz"
      sha256 "86d1348c8bb1ef13edecec19a0e68dc0db9b18b78f5de48d52ae7983edb9598f"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/cmake-16.0.0.src.tar.xz"
      sha256 "04e62ab7d0168688d9102680adf8eabe7b04275f333fe20eef8ab5a3a8ea9fcc"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/third-party-16.0.0.src.tar.xz"
      sha256 "ddc21cdd290df012f8aa719767d80df3c37f49cfdb087d3e814087dcfaebfc7a"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f86c7a1674bad4bdf8779c2102902d048d42d82bbf5c5a845eba4c4083f00b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c3430217f8154818e7c1b59aea5b590670852c72d1414da9fa92b3b18eb809"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c157889feba9ac2d038bc5019ed47e4c674822917dee2bb1eedc0f03050da32"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b35f22bad0c02af0af0245f925f0a7952bb30a18b1c48a70dae40d891cf299"
    sha256 cellar: :any_skip_relocation, monterey:       "6594499fc2efdaccef31749a5d977c932d67c9482b1dfdf2f1933e33ad96df47"
    sha256 cellar: :any_skip_relocation, big_sur:        "14f2a8f3c0e224efd711f72e5e5680fdfb70c70c8272a846642fc042781e9f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e4e2cefc6f445d7f73de14c2d940c860c5f6c1c6c396777d66d2101bc424ce"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
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
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
