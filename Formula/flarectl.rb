class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.22.0.tar.gz"
  sha256 "2021854e6507bf7ca1fcc5f767d9e8614ba9d1c48e637b6300bfeff5d6a6e59c"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "408b47919cfac498e66743a5274d99fee61874a2c145f39b5becd0c614cf12ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "630528b2d81c4058e16adb6a086413e8ed045f2a6480973c40549061769d0926"
    sha256 cellar: :any_skip_relocation, catalina:      "4631bde133ea8259dc672f3db5f066a5c74d1016f05c6b66f86e57894a4ee199"
    sha256 cellar: :any_skip_relocation, mojave:        "75929f509cdfa71f7dacdd7e38194dfb86b08b427d8ec3e809843c3c7ef891a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04dbceaf4c1a25706fc883dfb4824c93f609d0b2a48acbc80ec59822cc609beb"
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
