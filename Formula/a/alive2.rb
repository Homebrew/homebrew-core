class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 4
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  stable do
    url "https://github.com/AliveToolkit/alive2.git",
        tag:      "v21.0",
        revision: "913e1556032ee70a9ebf147b5a0c7e10086b7490"

    # Backport fix for LLVM 22
    patch do
      url "https://github.com/AliveToolkit/alive2/commit/a86aaa0ea44c5671ce3e998ec6d422feaa95b236.patch?full_index=1"
      sha256 "6645b59d29e7a4bbe45e91f57391cf9d4e5dbc27ba99a93c89ad13b14d57a7c4"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3039025bf1c344c9cc9c1dd9ecf3ce475bbd477cc056d683f8f482c45d022772"
    sha256 cellar: :any, arm64_sequoia: "d38a8fa8b85942ed8911686f2070cc5fe77f4e7d64e7bcfd656190fd3aa44167"
    sha256 cellar: :any, arm64_sonoma:  "193e847f12e1c6f8c7ffb50fc2c79f9612eb669a9410c6142847fa0684b5a89d"
    sha256 cellar: :any, sonoma:        "ec88f99b401d5bbcfdd7b710f2b1e0744ae2d7cf6624e3d25f9e7ec5206ceff5"
    sha256 cellar: :any, arm64_linux:   "a6202f0f73c17be042a286cdc4228743383c703593d23cdacb2153e6e1bc8877"
    sha256 cellar: :any, x86_64_linux:  "59149621ca95a00b201d8af18637f00a9f9cfeb79e0b8d5fc299510fc445fd5c"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "error: reference to local binding 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LLVM_UTILS=ON", "-DBUILD_TV=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    clang = formula_opt_bin("llvm")/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end
