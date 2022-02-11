class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.32.0.tar.gz"
  sha256 "cbae73969c538f41698042baf8f6a5bb3c9431ba4f05e47d8b75c908a960a5dc"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8260fd08f23289bbee0b9ef63a6518d2f50ae611abdeddd799fbc2017dd19b7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5847b7cd6ea709ce85f939595520a24dcc875c882ffdd16d39e43a11730c17ef"
    sha256 cellar: :any_skip_relocation, monterey:       "ca03348a7855fdbcd89c09d02b4a87be78798deb6a239d1e5bdd67270bd05c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eff7907bae2f860594d746a43510504f419470741849df4a79ef8ec5609fbed"
    sha256 cellar: :any_skip_relocation, catalina:       "6d07eea18c7441cc22553a51277008bdb06f876923b03126e4299305268915c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0df39d32aead4a793f732721223c5577f0766221fd4cbaed2a0d1f2440ac46a"
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
