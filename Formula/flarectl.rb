class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.27.0.tar.gz"
  sha256 "b7fc9518dd1e6f424074cd1e3e199524e27592bfe28a0281c05744b89ec0f4aa"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ad3f272832cab4fd9729563270ddc4125360492ee1e4149ff198146dbac0948"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8ce0308ff5aef0ac348861385d02c1b7414dd276ad83b44c46b1f39780aafe"
    sha256 cellar: :any_skip_relocation, monterey:       "7557115e016b3ed26c7b01eebde32fe208637fbeaf3e89517e5fb58986818992"
    sha256 cellar: :any_skip_relocation, big_sur:        "308f1d3848c586c10ddc73b41580554ebdd937e0eda5a59296e32bdfd3e44de9"
    sha256 cellar: :any_skip_relocation, catalina:       "d9766976aa0b8e208f2da253c49c1a41bbc43822becae30d6c075ec7bc5d3b1d"
    sha256 cellar: :any_skip_relocation, mojave:         "10e77db478afebbc494c391527bb977a8a48821d6572214801bb42521effeec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f26f9dd83669836a243810d0c9f227e494c6ff5232d76524c26d5914ff0dfc"
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
