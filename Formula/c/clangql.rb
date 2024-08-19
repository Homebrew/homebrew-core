class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.6.0.tar.gz"
  sha256 "a3ccd60735a57effe8a2aa9ee80ff3fabd1dc0a186365e20b506aa442edc3ac5"
  license "MIT"
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbc98d292a756d55349252eb6b7ef7ba89417928f2dcb300665c16f6d1ae59c8"
    sha256 cellar: :any,                 arm64_ventura:  "3a0eb7447e69d4fc62f832b6b392ea5069e50b291c7ea9b7cb1d4e438a27c8c1"
    sha256 cellar: :any,                 arm64_monterey: "85bc2eabea8e81c16da89f60a4ff077f8e53ef505244fdcc25cbb68394a79484"
    sha256 cellar: :any,                 sonoma:         "e269b472367849b0c751912a3b11135ebc817aab0fe2c0b05f11fdf4656e2508"
    sha256 cellar: :any,                 ventura:        "c3de99b620d3b8d8191e2af49a5c705d1c9a75f5a9c6aaf0c21d75babd673e00"
    sha256 cellar: :any,                 monterey:       "02eb426cd8bde020723c39b704873b3c4fba928856210911dbfef4217ab8949b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a14c174a32003873e6dbbafd965b2683c3f91312b48a34819fc4b543a61cd7e"
  end

  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main()
      {
          return 0;
      }
    EOS

    output = JSON.parse(shell_output("#{bin}/clangql -f test.c -q 'SELECT name FROM functions' -o json"))
    assert_equal "main", output.first["name"]
  end
end
