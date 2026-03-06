class Bonjou < Formula
  desc "Terminal-based LAN chat and transfer application"
  homepage "https://github.com/hamzaabdulwahab/bonjou-cli"
  url "https://github.com/hamzaabdulwahab/bonjou-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c24be4b7fa12eb537dd876e57b28634911612d299590a2a25ec518d8fd43a066"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bonjou"
  end

  test do
    assert_match "Bonjou v#{version}", shell_output("#{bin}/bonjou --version")
  end
end
