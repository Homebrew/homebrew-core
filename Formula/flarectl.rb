class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.31.0.tar.gz"
  sha256 "77a658c41a316673f304c7abe63258ee9fef9e515aa951e941f651cef11ad311"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47599b4e1c34680b517fe2ae9a0ffbd992b8debfa6116747e1225f0051a5ca59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4ee1e944734ab61f620b23037cf0a05e4af56d1d95817376ad5035048a8b95"
    sha256 cellar: :any_skip_relocation, monterey:       "9171f9160c0aceb6729b2ca9a3fa4447fca7e73a827b226ee9279217ae1bf3d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e99cc70742f35c6cfbaabd91b1b5df07d99ceaedf0aedbc4fdeea949d18c2b4"
    sha256 cellar: :any_skip_relocation, catalina:       "527c3f7799eb1948365b5af220339a9ebf741722c288f094b8511b3fe63e6040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7615c31b1f775ba167b59fc5ef8bd0e03cdc6051d639a88031558a7080bc7a70"
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
