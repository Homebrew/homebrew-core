class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.67.0.tar.gz"
  sha256 "9eb24250e84dfaaa2d4c3598033b557a77ce15af8694960c0a54f1dd31bc97af"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f23c657e95d053029efe316da68df3c10def0796785b1e72f22771e90502521a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f23c657e95d053029efe316da68df3c10def0796785b1e72f22771e90502521a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f23c657e95d053029efe316da68df3c10def0796785b1e72f22771e90502521a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1d6ceb7e4369e68e08ce47801516e56c59f179474be065975946d9e4787fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1d6ceb7e4369e68e08ce47801516e56c59f179474be065975946d9e4787fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d1d6ceb7e4369e68e08ce47801516e56c59f179474be065975946d9e4787fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b7b1fe3b79c281d3ba465643539901639cbe3eb0ef131002fc7076043f5dc6d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
