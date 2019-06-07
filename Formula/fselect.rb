class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.3.tar.gz"
  sha256 "cc0655057cc4a6ce771670ff72b52468adac27efc6bda1db08039a37866f2858"

  bottle do
    cellar :any_skip_relocation
    sha256 "e71b0b664a8c9f930793b70ecdca8c6b7d38dcc703a3edecb9ecd2c75b56e35f" => :mojave
    sha256 "416e1e23f5013fb9e86f20544e5265128ea59a5bff0494a718ab056e6b174487" => :high_sierra
    sha256 "0c183449a465c10a834897b18acc822b4c503e0daa316a438e926418208bf21c" => :sierra
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
