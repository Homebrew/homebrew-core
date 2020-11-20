class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.2.tar.gz"
  sha256 "8b2cbf8aff709ffcab49ed59330655669ab185a524e89a101141d80cc025063b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a59d8f537da54a5b7830e48eb42b1911973820a5a86555d76e4a9760d79f9684" => :big_sur
    sha256 "7da995ae54157a3ecdaa8d5799a1a6b2356c6e8cf3ba2291ba29502c1d422053" => :catalina
    sha256 "ec6594a93ea9d8034833603fd78ba3dfbc2b6095018ea8f314b383c566f73534" => :mojave
    sha256 "d9fd1eb3acdda1c204adc4c7c2424ec0cc53e9ce0b516a92506ca04fe2ab21cc" => :high_sierra
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
