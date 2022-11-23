class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.55.0.tar.gz"
  sha256 "eee560662602fc98f5502482a364bd77441d498bab27d60a1c9ec06d2c14882d"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da163b1680a6cbf8226ebb3dac5dad21564f88cc5aea05c97425313f8872e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54e5c675c84c03899a68916b7ad2a5477a156d3cbbc7ef512252c2e2b5b7ed67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f048e38cac0f4baf30be52336384e3c517c07a961d90a3c0f847aad62f31906"
    sha256 cellar: :any_skip_relocation, monterey:       "309829400937ca37389b4a8e44fdbc2acbda23c586f1a9e4a5efe1c108c2eaec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b007b8787aea4602e65443642443ac7bba86b941d8c0b473588d6eb39195ab92"
    sha256 cellar: :any_skip_relocation, catalina:       "fd476ed991ecdc5d70b2e364a382a93a31e710ea60b60a5d17046a88b309b049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "624cce7f1bca662159c6c397804170527dda0a524f269d136bf1ff07b700c5cb"
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
