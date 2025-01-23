class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.9.0.tar.gz"
  sha256 "da6ad3bf11a12eed63a7f92149315fd419f371f1935be3e26b405bb0fa46f31b"
  license "MIT"
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4e91252c30f653864d01a31273e35bcf4e37acb724aefecf0765c7a76e79eff"
    sha256 cellar: :any,                 arm64_sonoma:  "f146f5b00c096e057e96020923f2a9adcc8efacc5d91c7818d76575c5768ff61"
    sha256 cellar: :any,                 arm64_ventura: "756ef36347451bb2d8758f517df05d880ebbbc26ffdb92ca714698db76a9c8a7"
    sha256 cellar: :any,                 sonoma:        "7100a9c07eab226d4595724c468833ff3a5aaebfdbfc566452236764aabadcb9"
    sha256 cellar: :any,                 ventura:       "b7b54e88a6d304f5c997bcdef6ca93c6080310517ab0612719fc1e11295d516f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e839576243b1fa2c349642f8f3a80a665f5aae5d04ae7e0bd3501776bf84afb1"
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
