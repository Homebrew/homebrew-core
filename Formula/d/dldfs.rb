class Dldfs < Formula
  desc "Blazing-fast multi-connection CLI downloader with IDM-level performance"
  homepage "https://github.com/Mark-0731/homebrew-dldfs"
  url "https://github.com/Mark-0731/homebrew-dldfs/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "1172f591f367ea582b79cd63f69536b5cca7d017befd3934b4e55166cd382b3b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "dldfs", shell_output("#{bin}/dldfs --help")
  end
end
