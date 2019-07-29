class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.4.tar.gz"
  sha256 "a4ae5907f3d73162f60a1cb5178115b3a88fca5df3270fd03512cd429be1271b"

  bottle do
    cellar :any_skip_relocation
    sha256 "70bf05578db47eec617f1294ec4da5e9f2936fb898f3554ef016be5f140ebe3e" => :mojave
    sha256 "44d760d5a862a2434edfa987aa8cc429bdadb3feb383fbc8d24d74ef3ee8c773" => :high_sierra
    sha256 "e0ad364b3d9c8b87810623c2f92d03394f65c166bb1fbf8eaf6e3df7eed8a814" => :sierra
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
