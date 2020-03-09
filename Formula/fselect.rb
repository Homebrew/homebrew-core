class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.9.tar.gz"
  sha256 "8a280ccd96c9aa0b638065eb4d17e9e75a185a89afb56d0bae522645bd8b3c66"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ae070104402cd0d37b7ad05aa6ae72bf7413984a0c1de622b57b94d833e7636" => :catalina
    sha256 "3636cfa901b7867e4874ae130ecf4a991a0343c8a011a1c4d0dbb816604376a7" => :mojave
    sha256 "ef74e79690e57dbd7b06b112cb62f2ccd06c6f24d17fce28d170c81a9abf34a9" => :high_sierra
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
