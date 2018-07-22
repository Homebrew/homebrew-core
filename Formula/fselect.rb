class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.2.tar.gz"
  sha256 "8e6978de577dc73cfcb3725b02cf184b09dc7e35bd7957e8cc9ca556038cc71c"

  bottle do
    sha256 "bde60b778534ff4e6f199d7d30249eb53d11b71b3c9342c65c5096feaaee0453" => :high_sierra
    sha256 "d4eacbba6f24de0a3437774d233a0d4a17d59d94c02ca082a9ec6ffc4501521c" => :sierra
    sha256 "ec4b3ba4ca9cae917df8e8a983e0322bcff8e2d6c3f8c1d8e5c3d61e28ca64dd" => :el_capitan
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
