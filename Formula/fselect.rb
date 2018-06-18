class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.1.tar.gz"
  sha256 "785f206030b71f0117c975226f490aa370ee5eda36597010677794b539151743"

  bottle do
    sha256 "c9e2a8232f2e2a0cf90605d6bca20fa2557161a5705002abc1f9604098052ed8" => :high_sierra
    sha256 "aeaa8e4491997ce983d3a09b960fb73e841c6c9e450bbe673ed8a4d529e76cab" => :sierra
    sha256 "4fede4a9a9fb5208bba40e3f70594c7a0c4a8e2f268f8aac46d2153a7b80fe2f" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.txt").write("")
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
