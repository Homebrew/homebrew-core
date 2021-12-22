class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.29.0.tar.gz"
  sha256 "a9816362e96030f5981250b4a91e313190ad6ed5f49094425490947d4afedcec"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db3363e64a9a9c25c7c66bebb369558f4684713152e9907438f642622639c39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9fc17fa82dcae782321ac1f649ecba7d448baee0a30e940ac042dd7c0cc9631"
    sha256 cellar: :any_skip_relocation, monterey:       "8287c2177d371e02999d5ea3a77d61e091634681d3efae727b1abad0b757b0a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a334927978703968123e7823fa42e60723f31baa493e98078c96d48a941da046"
    sha256 cellar: :any_skip_relocation, catalina:       "5bb0aa9a05fa24f5dd8a3a15fbbe2796b1d887f818c103698f9e824df6ec0801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a52bd8ba2b403783e7e3471c10aab9e49e4c48f068763f4cd7ad635ddbefde9"
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
