class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.3.2.tar.gz"
  sha256 "9aef280de65b8ffd91993c6eb6321c8fdec4281f3490b070da832b307f8ded1b"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fselect"
  end

  test do
    (testpath/"test.txt").write("")
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
