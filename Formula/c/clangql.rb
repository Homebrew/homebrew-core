class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.23.0.tar.gz"
  sha256 "89167e051aa0bd032109e86b56597279c74c6ed09bae4e86331b846696bc02bd"
  license "MIT"
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02785e5e478d81ab65d4ba22bb52d9d63de81d4c33485363c972ebd6f6ae804e"
    sha256 cellar: :any,                 arm64_sequoia: "eef86c95f3a709e4e4049ffb6ff811fb3940d46a8875cb46037a8a0b8a452030"
    sha256 cellar: :any,                 arm64_sonoma:  "0d638c4d2f0eb2d515dcff9f522fc1ef94f6bcd6569cfee7a71ecfe7ff5249f8"
    sha256 cellar: :any,                 sonoma:        "4b164924eb731e51b32b6d7bba098b3bf2fa3e6557b85d64d3641649e1f2fac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfeb186e26729d019ced82cf94306af7ccc13ef03cc7a6d7d5d97c6332b7044a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74cae08c14d98f1e672d1ea149d28a299fcb698a6d657a1216c0e5ef95dca2e"
  end

  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write <<~C
      int main()
      {
          return 0;
      }
    C

    output = JSON.parse(shell_output("#{bin}/clangql -f test.c -q 'SELECT name FROM functions' -o json"))
    assert_equal "main", output.first["name"]
  end
end
