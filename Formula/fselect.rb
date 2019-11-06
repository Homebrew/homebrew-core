class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.6.tar.gz"
  sha256 "bf97b166b1f0c55e27c85943f3335ccec00219123b364863c0132f7d29d39e29"

  bottle do
    cellar :any_skip_relocation
    sha256 "06dcd013ff905155292afb6c59403f360d4e5f87ec0e4ae9f14b9a8f0a8c722a" => :catalina
    sha256 "2ae76542d41194210969879ef52d905dfda7f1c86e7e37c3406febcfd500c5f6" => :mojave
    sha256 "b2ef2faf383f377140ee889256267f17be1da42d2c63c469341d7892f0f66ed9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
