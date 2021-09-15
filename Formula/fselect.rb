class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.6.tar.gz"
  sha256 "bea8a7c09ddb88a8ad253305744847c4e4d63cb16afbec6c8cfff89b264f67d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57571c72929bf97d6992c7c8f7826d6ed1574bc29ace961429ff563524ef8452"
    sha256 cellar: :any_skip_relocation, big_sur:       "a662d57fb34649294ece8d5e75332f73bce6394bf139d31167c4a2a83b3d59e6"
    sha256 cellar: :any_skip_relocation, catalina:      "3a0154264d20257b7376d49be91a9d03f24624fa1e57281cbb79640038e9b1ae"
    sha256 cellar: :any_skip_relocation, mojave:        "16259c0ce60aeba0646452b3f7081a1ad9a7233bf30b3981da24624b781b9790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffdc104dcdd3060fdc227a132be59dc9f7cb9e28ddb3d4e9bfea561fdb85e030"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
