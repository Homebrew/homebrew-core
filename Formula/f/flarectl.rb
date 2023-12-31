class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "d71fc0d318043b8fd252b46cf0585cc90d801ae15bc77ab0a9dc0d27f9f79db7"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "323dcd16a791e43595fc9f8c3d5725bcb7024d4504c64757a7a8e272e8339a0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e721a2a8439e111ded3e2f9e8dc345c3c0d9c23c77a6b5d2533122e2ddee404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a798546538ae7c3324cf699fa9581c8edd4c581de9e316efbe4db0104be3a712"
    sha256 cellar: :any_skip_relocation, sonoma:         "78533a2b5f75a9530c976027e06971e76bdd27120445d9a84d980492161fe698"
    sha256 cellar: :any_skip_relocation, ventura:        "b63dafe471439f4c1d86496d11563a1215755579b7c9fe53a79f4340e7c6717d"
    sha256 cellar: :any_skip_relocation, monterey:       "589347e6df7148e25585b24dadd3ef045a9a15dea349a5d92ae06b8fdb870d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f3f631a421ad70808283343a3004a7f864e708930344b5920470e34d9d8539b"
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
