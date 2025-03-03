class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v19.0",
      revision: "84041960f183aec74d740ff881c95a4ce5234d3d"
  license "MIT"
  revision 1
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0e3e3a540b8d9d2fee6e28caf8392b234771bdef828dd290fa7b96f455d069a"
    sha256 cellar: :any,                 arm64_sonoma:  "5514d92df672c7073060c36b23c1eb1b3c752c82a0282a93e029a020d4e5aa8a"
    sha256 cellar: :any,                 arm64_ventura: "3bc3b48d9232f046ec198571cad9bd4efbe8f3a2b521ef3b0cb77f4b6aee5c1b"
    sha256 cellar: :any,                 sonoma:        "69a9e839094cf26f9a364bc9fb2b602b4008b361dd38296bad5f70c370d40323"
    sha256 cellar: :any,                 ventura:       "e67a8a8978bb0abdc51e51378876212569de77f90357e86e9d3dc6cecdc3385b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35fac67b30fbc40e37bbe6e4aaef4dbd0a19cd774095c0485b2c03c6e0c6d1e"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm@19"
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "zlib"

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
