class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.5.0.tar.gz"
  sha256 "90d785f3f24899a6adcc497846f29112812a887c8042d0657d6b258d5a5352bc"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match /(\d+) B \(\1 bytes\)/, output
  end
end
