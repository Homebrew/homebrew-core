class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/V0.77.0.tar.gz"
  sha256 "4808931492db33f429850fb3e751208771d6618c6bb0ebac837dcf301d8b9d2a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9387e65297d3593642ed727f8f39facea2107b404899adbef35b351b9cb89718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fded66107ac5b1d824b341f8f33aeb4b8c8cda393eb7a7de4d49d745e6599ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25dffc613857f34e8f3791e9c99552cb6eaa3cc101c4ac5938a6ee88a7c61f9a"
    sha256 cellar: :any_skip_relocation, ventura:        "e79a6eb44ebcbc0d2a5ea196bfde42981be5b75c8cda01d9546ade4f92a7b8ff"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcd495cb3e6a0c647a4f4b33d4d510e77f7928c85d6ec38f2a233d34898a927"
    sha256 cellar: :any_skip_relocation, big_sur:        "62bd8d4d8e388ee9e21f0fc220280f2d520080e17cf7561906c5377908c38165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8edeb9b254b4b2bf285e3ce44fd9bb8c2a98925fd43ffec0893a0b4cab27bc4e"
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
