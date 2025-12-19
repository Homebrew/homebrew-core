class Gclone < Formula
  desc "Clone git repositories using SSH profile aliases"
  homepage "https://github.com/rickyseezy/gclone"
  url "https://github.com/rickyseezy/gclone/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b58b0a4838fe48e7f6fd66bbd4f810601bf259db34649ce18c1b333f306a769a"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gclone"
  end

  test do
    assert_match "gclone", shell_output("#{bin}/gclone --version")
  end
end
