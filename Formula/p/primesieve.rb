class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.13.tar.gz"
  sha256 "4cd3f1b70f6b02d695e6495e6a0fc0fa99b4dc043e0f21686d2cf409e98295c9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14ac2584e2e13ec4d2154342a6928be5dd798abcd36b3968a98294a36ce938e3"
    sha256 cellar: :any,                 arm64_sequoia: "bdd60a867fc72ed814861a1c734c43e72baf14a9ee761793c9d492561b4fb335"
    sha256 cellar: :any,                 arm64_sonoma:  "a4818c04abfd735ea1f7a59be08694512a90fd2ac9bd613a17b8ba908488f926"
    sha256 cellar: :any,                 sonoma:        "085aa6f8743c2d186c31aa02a0df8d66b829d17539c771bc2db94fd6c0dba04c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29cd0c69ea9f6be89d8da4fb8ff25c63b360f21c974dccbbb908bbd34664ad6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458c1e93376e3e244d8c4835f6cbb0b3b34d6e15a86044c6249ad29e57271e65"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
