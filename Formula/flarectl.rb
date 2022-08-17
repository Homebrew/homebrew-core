class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.47.0.tar.gz"
  sha256 "b54bd854388004f894a9651ef08e1d36d0a429de5f7f12b8aec0fe579ecc8614"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c668b9295aa644521917908d4f377b0b92197881d620c274efa981400810d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976537c2f633a4b493b390989c387f2ae725f8468efa11cf942d1146541304ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c9464a4ae9b7bf1eb32d237d581fd38640f04a2cdafa529f3a040177423d2e3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "82afde1fec1fc7c4fd8de9ff239a99948c43450f87aa221607897f28b824bc71"
    sha256 cellar: :any_skip_relocation, catalina:       "b2cdc387c4decf80d82c70115fe724176ba571147cc1cdd87e6ae1fda2aad9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a243b9656ac4b81a137f1611d9897fa3a6c2c8fda97dec43a22f45459ce2078e"
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
