class Dldfs < Formula
  desc "Blazing-fast multi-connection CLI downloader with IDM-level performance"
  homepage "https://github.com/Mark-0731/homebrew-dldfs"
  url "https://github.com/Mark-0731/homebrew-dldfs/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "28cf739813494bce85c7b450d86a45ef70babf05f8ccd01027ab3949ed431702"
  license "MIT"

  # Bottles will be built by Homebrew CI after merge
  # Users won't need Go installed when using bottles
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "dldfs", shell_output("#{bin}/dldfs --help")
  end
end
