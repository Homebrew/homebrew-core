class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.10.0.tar.gz"
  sha256 "216a8faf76cd59f149bac4800cf7bebd5c709d6f97abbe4fffde2f9585f7c518"
  license "MIT"
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d7d3dec4acffb5b26561003d115b54fb8c0ca6c137e5796ffc97e21c0a5d521"
    sha256 cellar: :any,                 arm64_sonoma:  "35f90c49a03e4b853dfbf18b9dd32f1c42f84ca169937c500e6ed905c02663d3"
    sha256 cellar: :any,                 arm64_ventura: "f604b5653930a425e60e2cc950b37d8e29a03d376c9274a0593238c40120047c"
    sha256 cellar: :any,                 sonoma:        "0f65e6b0883e4400c4e34d798512f45ec72418f20032b58d6df2584d0890a2dd"
    sha256 cellar: :any,                 ventura:       "699ff49df43c3573ec8af08088f74a3cf22446455b3a04ad70236f1119963f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f5f96f98ecc434bb4384c83c3d5d1e9569b3865b037749ac54ba12806d4ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5764fcf9ee640feb9dc8867101bfc613365aa5c96963d16070486039acc88f"
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
