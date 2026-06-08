class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 3
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
    sha256 cellar: :any, arm64_tahoe:   "445d01ba24440ac9071dde675e08196bab08171e8866de24e30301ff44a37619"
    sha256 cellar: :any, arm64_sequoia: "a3d8dedf0d6563fdcf8f971af326e8ac14460d2f4d58835c33c010272bac9c3e"
    sha256 cellar: :any, arm64_sonoma:  "cdf7d503fb59cdae4e53e46f74330394ba297f229f4206f1a3fdafd27ce88aac"
    sha256 cellar: :any, sonoma:        "71b7200bc1eee6108cc190825afcf9de7e40ecd2382184524ace1b4fe24cab1c"
    sha256 cellar: :any, arm64_linux:   "e9f00c07416b06bca256a92e9b0d43f37cef9a68a938bc8aeaee347e01a1ceb9"
    sha256 cellar: :any, x86_64_linux:  "a6fca00321fa9f45065dd29cd0a1bfe14ce220121fd887a0dc5f171e3f8ad9e6"
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

    clang = Formula["llvm"].opt_bin/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end
