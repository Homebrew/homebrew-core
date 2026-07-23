class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/v0/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.117.0.tar.gz"
  sha256 "ae76bd5a05eb9f4f8971904377e9570c80a526d670b484d9a31ccd69638d256e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "v0"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "821166e5088d2090e5ef596a85c40997f0b5ef179ef26666ca47e645deaef115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821166e5088d2090e5ef596a85c40997f0b5ef179ef26666ca47e645deaef115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821166e5088d2090e5ef596a85c40997f0b5ef179ef26666ca47e645deaef115"
    sha256 cellar: :any_skip_relocation, sonoma:        "714856fa20a429f791690d3444c3ed9ab7ec0891a935333fe6c61d5d03d54eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81822bbee1f3b80b60e210b29750e07177d74d6ed2d9483160d17ec5156cbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc8c2f617275a53067d73bd0a681b10ea0f2a81e9904fcf8369b06cee6fa868"
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
