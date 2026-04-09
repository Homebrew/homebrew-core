class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 2
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
    sha256 cellar: :any,                 arm64_tahoe:   "2e00cec934b19e6e0782c0cb50f5bc1e99700d05d30c303306cef3290e477cbc"
    sha256 cellar: :any,                 arm64_sequoia: "564aceec0c207995bdf1a7c52af3c85d294520a241dc9a640fcedd7987be9cce"
    sha256 cellar: :any,                 arm64_sonoma:  "f29e72693a3db068ad2d63c04008c12a304d03e96beded350fee908f129b9296"
    sha256 cellar: :any,                 sonoma:        "c1bc73895f64d8c25d4c5b91e18787cc2d02ef0aafd18f0c87b60ec2ab8363fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c77e368b62bbd426c27ebaad1666c6aaa5d7aa75dd0ca7c75d1103c419113de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d1bf9e90e54266e4d36fb5193dba3f668b826f3bbc0363e012c2f31f6e1029"
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
