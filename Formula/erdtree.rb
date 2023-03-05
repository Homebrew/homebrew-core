class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5114f694d2430374ce4d251613e16acfa1e5d34a911306062cdb43f7f6544ea9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
