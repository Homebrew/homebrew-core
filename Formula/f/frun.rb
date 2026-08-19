class Frun < Formula
  desc "Fast terminal UI for flutter run"
  homepage "https://github.com/okasutarto/flutter-run-tui"
  url "https://github.com/okasutarto/flutter-run-tui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "31e87c0522a638e328a036ef502c6ea0c786f167bc6544f5fcaf372047d29cf6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "detecting", shell_output("#{bin}/frun --states")
  end
end
