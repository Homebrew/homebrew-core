class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.68.0.tar.gz"
  sha256 "f94cfc22a13eb6f4f0ffc3550b98c7117f9e9d2fa241aa6d26a5134fb516baa9"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f84f7dfc5fd30fd2a055fee889da017ea00d133524804e43faa0e066d8830bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84f7dfc5fd30fd2a055fee889da017ea00d133524804e43faa0e066d8830bf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f84f7dfc5fd30fd2a055fee889da017ea00d133524804e43faa0e066d8830bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "cf40097394dd11e82b2cc26ebe415f0aed078b160c5877eed0d802d39db9808b"
    sha256 cellar: :any_skip_relocation, monterey:       "cf40097394dd11e82b2cc26ebe415f0aed078b160c5877eed0d802d39db9808b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf40097394dd11e82b2cc26ebe415f0aed078b160c5877eed0d802d39db9808b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32818ea9b6d74e299de171dbaca03ac54a3288533397e37277e1494188162627"
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
