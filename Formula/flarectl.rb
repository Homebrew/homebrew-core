class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.36.0.tar.gz"
  sha256 "2a453f021be34a9406e91f4452eae6138e8355f5fa30cd140560dd995177ccd5"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "815a87608993209eb9d85145db0ece967aaa12569af5947be2ac6ecf996069c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e509a1bd2cd9fd9445df8333d21bfd03b513138b650029ab19480aa6c4a901"
    sha256 cellar: :any_skip_relocation, monterey:       "625ddb4889dfb2e48ad818b05cfc2c37778619546a82d396523363fcc7e7407f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fedf96f87c48ed21961f0c691f2650588ec7d4e6f95b427e2b1c4e0494d95fb4"
    sha256 cellar: :any_skip_relocation, catalina:       "a34e3cd2e54eed94a3a85b166d37de9efb3eeddfc854cede0b84542724a2bae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f5f9fccef92919eae5745d5ff95132221bfe355f33e0adf7d399841f8eb08f"
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
