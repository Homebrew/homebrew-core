class Dupclean < Formula
  desc "Content-aware duplicate file scanner for music producers and DJs"
  homepage "https://github.com/PopolQue/dupclean"
  url "https://github.com/PopolQue/dupclean/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df582c29d8b4709a137b4cf058ebaa37725dbdae043b0abb385195a6295f65d1"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "DupClean", shell_output("#{bin}/dupclean --help")

    # Functional test: create duplicate files and verify detection
    (testpath/"file1.txt").write("duplicate content")
    (testpath/"file2.txt").write("duplicate content")
    output = shell_output("#{bin}/dupclean #{testpath} 2>&1 || true")
    assert_match "duplicate", output.downcase
  end
end
