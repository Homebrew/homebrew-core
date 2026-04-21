class Formanator < Formula
  desc "Submit and manage Forma (https://joinforma.com) claims from the command-line and MCP clients"
  homepage "https://github.com/timrogers/formanator"
  url "https://github.com/timrogers/formanator/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4bb7128d4f1d276138b3d182f5a1d55fdc428a9af9e8306d7d6ceba37cbf7155"
  license "MIT"
  head "https://github.com/timrogers/formanator.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/formanator --version")
    assert_match "Usage: formanator <COMMAND>", shell_output("#{bin}/formanator help")
  end
end
