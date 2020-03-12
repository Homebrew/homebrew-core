class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.9.tar.gz"
  sha256 "8a280ccd96c9aa0b638065eb4d17e9e75a185a89afb56d0bae522645bd8b3c66"

  bottle do
    cellar :any_skip_relocation
    sha256 "64da9563e3aa17c48574a8ddcedeb3b86d69bb7e9c9bbdd705e37de2e682380a" => :catalina
    sha256 "72bfe29d9c29b6d3592074b18142289e629b43e017c9c2c7bf3ddac573d4ec0f" => :mojave
    sha256 "2499034e2890a202bd7aff3a71a0cb5d6d75d55be3852861384db0bb7443cc4f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
