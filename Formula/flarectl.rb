class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.23.0.tar.gz"
  sha256 "7730392992eec1aabe64e28dc1d7565fabbc6f401f016c7f136b14ae1bfc30fa"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dcde4d571ab406984b3553525882d3e3c8a4e8776f39b66b11e80627410b7f62"
    sha256 cellar: :any_skip_relocation, big_sur:       "b853295858559416e30f5ccba234fea488cd413157d6acd5ae425c77307b9b2b"
    sha256 cellar: :any_skip_relocation, catalina:      "f66c2cb9d0e1a308f643e2dfa95d642a20033e3c63bbee9113c246cac6d941c3"
    sha256 cellar: :any_skip_relocation, mojave:        "ac01c61acae4446846c223ec4c53ffb20da5307476df0cd4292420d127b643fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "228b02ab6b5f62a23444a4acfc97547a2254fb32d1597c96fb6a8ca2b3a910b6"
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
