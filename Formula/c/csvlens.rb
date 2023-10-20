class Csvlens < Formula
  desc "Command-line CSV file viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4c327487eb9958ba089c68748e224533e53f8d7066ccc43a21f51ccd0e44dee0"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "csvlens #{version}", shell_output("#{bin}/csvlens --version")
  end
end
