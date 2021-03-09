class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.14.0.tar.gz"
  sha256 "c4a7b298d0e5519194278257131c3d51a19b2460e845fa1cfe20bb579b8af08a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "921a089c949c97f1535486c8762d2cafc0cc60064a796ee42ede71ee887b85b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c4e25453201f06ef765380ff1a982b83439f6f11ed1e7fb04ac8990504b5869"
    sha256 cellar: :any_skip_relocation, catalina:      "e7baf7263b0eb7785a724b8c79a28cc767f9e440560e2af9d9e1d7911cae2ef8"
    sha256 cellar: :any_skip_relocation, mojave:        "1327331e659ae7ae6bf74bea4577b82819811f7eff758060cbb4ec74897eb9df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
