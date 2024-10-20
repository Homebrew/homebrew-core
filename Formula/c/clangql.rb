class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.6.0.tar.gz"
  sha256 "a3ccd60735a57effe8a2aa9ee80ff3fabd1dc0a186365e20b506aa442edc3ac5"
  license "MIT"
  revision 1
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a41fd14cbcc68edc77e341d8725671075aa6a3c9bfc400e4b0d667eb60f2cc9"
    sha256 cellar: :any,                 arm64_sonoma:  "991a56a1b490e0ef3a1f427b7178a58a91e2f498b14ff1f78952ed3e0b7ebf87"
    sha256 cellar: :any,                 arm64_ventura: "567287dde36428bbcc0092fe2a5a7a10c4a0447666ee0f1004fb618dd2384f64"
    sha256 cellar: :any,                 sonoma:        "2625be86efa34744aa3929ded98338ed025bb3ef7cd68c9c82802baf57570853"
    sha256 cellar: :any,                 ventura:       "78882cfb83f2dec937e239ebe80a5fcc044ac734bd17be36c21770dd644d6933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf09677c105b5159e9e11373df883b123a5fce1c448b64b5cf7ebc9c1311eca"
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
