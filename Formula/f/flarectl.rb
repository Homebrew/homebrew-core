class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  # Pin to 0.93.0 as cloudflare-go v2 does not produce flarectl
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.93.0.tar.gz"
  sha256 "406f6e1a8fc5b2a15c9e47d88c1d864a2073011162dc29c82e3e39201d1f5211"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7045a8a2234cb2497a3f82315bfb5b14f37a79ea52bfdc228fb6fb1900acf10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec7bc1d1db61b6ad4563ccf6420496e63fa98dffc7002047747dd85eb8bd1350"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f46ee52270ad9d96f6603805c81a99f582abf86f6e08fdaf172ec4909a5ec1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad70f1ddf82af37babf678707603744d770f7384f3a5893c3dd968615ac01d8"
    sha256 cellar: :any_skip_relocation, ventura:        "b20b7ce2ce0ab78e8ad250188d270972578e7340c7aef8123b6cfa0a68e6de18"
    sha256 cellar: :any_skip_relocation, monterey:       "976f8bdde1a3c0bde921e3d5740eee5b9ffae5c9e356c10791d2ced590f0d6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb9ac5225edafa04d3a102f14e6dd83a22a60e49e73d34ae5aef1e792023296"
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
