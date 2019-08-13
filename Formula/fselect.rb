class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.5.tar.gz"
  sha256 "6c50f0c7874045bee7721c8dcb687fa1ba2278f4eb86c4e638d4b1c8592129a3"

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
