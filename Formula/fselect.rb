class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.8.tar.gz"
  sha256 "06dda3637929d34eb8788e18ddc4f46d92855691049e342fe7a67b3fa26d1d89"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db07ab70beaf891be7249f6cb3a457198dabd24f6136edb93725576442ce3f40" => :catalina
    sha256 "8e4a8e4acb099cc10506050bd7b009a1401960e5a4cb3a476cf4fdb1b68d158a" => :mojave
    sha256 "1c46725732d77887dd3f9e7103ef1c315ae654ba4b2310f86a49856d91eec8f6" => :high_sierra
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
