class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.45.0.tar.gz"
  sha256 "daaea3417353e0a03775834d30dbe09a319c6ea1eb674ea94a7113c6f993dac8"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7332c318906c61013b91e4ff773b1c74e30844e94e2c2c639b23f608ea6bc031"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9cf8664bf95dd5d2d31c217c452281f0f8935089e6dd2c06b458147a00f150"
    sha256 cellar: :any_skip_relocation, monterey:       "bed66326472ffc7187066d83dbba5dc309e94a9f5551fe19e6a6f643de1ece2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54d4a23d6aa5e574017339ee990bb553d79895184ecee9507b3c092546948ef"
    sha256 cellar: :any_skip_relocation, catalina:       "8883aa340d53c14d692b282866b0b3b998bf7c7511386e8356da31a36cf2f8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3a069ba39d620a95359b43c8dae65cb64e33b91c9a69662da00016f238604b"
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
