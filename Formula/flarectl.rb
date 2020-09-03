class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.2.tar.gz"
  sha256 "231132369b0508b35018fae37b9c863b0029e4f029663647e8e3d41f8c568f0a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "501d90b9b83b8fd898ceb43e3cfed81d653cd5dde92213a85b6a1e7b86e24043" => :catalina
    sha256 "d44748d6dd6550bc3a8940f4c2a91451126b774cc6233480fe717f16d8a6f5df" => :mojave
    sha256 "1e202ff7da87a0e66c2529c693e45d6ff8cb456ef5c2751d2a5f7d2f3b400810" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
