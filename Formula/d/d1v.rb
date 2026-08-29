class D1v < Formula
  desc "Command-line interface for d1v.ai"
  homepage "https://d1v.ai"
  url "https://github.com/d1vai/d1v-cli/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "0240a6c6324926b8f31b94e87d94d86578bb673f0725df6364b1287f0476329b"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "d1v-cli")
  end

  test do
    assert_match "brew-test", shell_output("#{bin}/d1v init --dry-run #{testpath} --name brew-test")
  end
end
