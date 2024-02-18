class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.88.0.tar.gz"
  sha256 "f8b3a64180aa1f599df525251920570b0fea0da8ad2e235f3a0865f64179025a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2134b771eefd3db6d1a0cf68fea56bd00283c9fb97b31c1f7d7639d4d1f66bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43095bc89fd6eab66c9069f3c733ed291ea12b362c13871e854316f086f0625c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48b2cdb65034c639b6e9b19962d3915ea77442a36c9d69e9bb2a0b46d1206a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d37c9ac742510988578547d76c35bb1749622cc5a93d6aa5791e55952ea1d167"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3c328a1f45c23061a8ff678c73f2100cd1d2369fae6797b0bd9e610fad5e11"
    sha256 cellar: :any_skip_relocation, monterey:       "4cfc0b9450503db7cf8618c65110e4c1b023f29645809eea96fcfb1e03bb9505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f2c99222e90dfc51d0badf0c69d0d2c617630293df29becac4b7ecfffe3cc7c"
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
