class Dldfs < Formula
  desc "Fast multi-connection CLI download manager"
  homepage "https://github.com/Mark-0731/homebrew-dldfs"
  url "https://github.com/Mark-0731/homebrew-dldfs/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "28cf739813494bce85c7b450d86a45ef70babf05f8ccd01027ab3949ed431702"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/dldfs --help")
    assert_match "Multiple concurrent connections", output
    assert_match "Usage:", output
  end
end
