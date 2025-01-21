class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v19.0",
      revision: "84041960f183aec74d740ff881c95a4ce5234d3d"
  license "MIT"
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1b49e7b8ff1d75cf940356abbae5fb24e1eb4c98eb5996cb82c8f468c57be12"
    sha256 cellar: :any,                 arm64_sonoma:  "eef8b5e1808dad01e28663608edd5cf4c196a58aa21e8c19b43ed3bdca7a13a9"
    sha256 cellar: :any,                 arm64_ventura: "a0b0620bac542b9a9067fae258a7aa472e73dd9f3e96259cea710cd9f0aa82a5"
    sha256 cellar: :any,                 sonoma:        "a268d8150ed4ce823ce936b72b0705cc3b9caf98caa2d712d3fffad91cd7bb6d"
    sha256 cellar: :any,                 ventura:       "b592aab1e5a63b34937635b6ded501eb00165cff0f6aae27ec34dabcc610f1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e1edb38168efd19ee4f31d290ae1f30fd1a73591ca49177090e13a938a1dca"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
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
