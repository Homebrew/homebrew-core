class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.25.0.tar.gz"
  sha256 "8dc7a58c9e0f7d74a2a89da0f6aa23e8ebeee67838301e091354fa3d9760cbb7"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b189a4d52ab029e761caf884e478448d9bdaf947b7ab48b108bf93539141d142"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8d6cd1138d003e041945faaf7a3e34a0e783be510c79986003d7b05f26c71fd"
    sha256 cellar: :any_skip_relocation, catalina:      "55789a68ebae038d5f9a77182fbfe3c03a174293c0a0b2e21c84c840422bc22a"
    sha256 cellar: :any_skip_relocation, mojave:        "d506e9f56227a5bba3ee64d3b1c653885e3e36aad548b16fba55f892c0d32531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3fddf09e7318a442a8716bad8b592fcaf210a0b1c5e69f66931dc2f166e07bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
