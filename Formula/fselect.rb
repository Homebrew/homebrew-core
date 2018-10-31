class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.5.0.tar.gz"
  sha256 "0bc9cf437ef4bdb7ff8abb18cae5b8e8489aa3ab66f5312acd9593a30361e6d5"

  bottle do
    sha256 "2f9eb65716c4000dea6ebfe7e9b3be8f79257c4a723d9751bc9b8476336a8f4a" => :mojave
    sha256 "340a2f1457d87e0dc7317cbc729dd929b6248aaf0f441218a0300be1ade0701b" => :high_sierra
    sha256 "06a1534b2cff43671bea6148e7a5db8469b0d033b027155edc74fd434388bf29" => :sierra
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
