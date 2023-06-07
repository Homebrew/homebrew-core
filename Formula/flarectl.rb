class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.69.0.tar.gz"
  sha256 "dece25a7765661e6d3a7ee3b66eea81169aa9a30065f199d31624d9a3f5bef10"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dccda379f456cee61a7d0a0b0490cd8c67c027e90205d1ce7a852f1bbfb342b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dccda379f456cee61a7d0a0b0490cd8c67c027e90205d1ce7a852f1bbfb342b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dccda379f456cee61a7d0a0b0490cd8c67c027e90205d1ce7a852f1bbfb342b2"
    sha256 cellar: :any_skip_relocation, ventura:        "ca272512bcf10aeaf07dcba135b9ba7a237a2848e8bb99d0896dab12d174b00d"
    sha256 cellar: :any_skip_relocation, monterey:       "ca272512bcf10aeaf07dcba135b9ba7a237a2848e8bb99d0896dab12d174b00d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca272512bcf10aeaf07dcba135b9ba7a237a2848e8bb99d0896dab12d174b00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66e6e010d95aa305061b9a66c7979fcdaf167c6d1d0e6782273c5c7a4b3fc95"
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
