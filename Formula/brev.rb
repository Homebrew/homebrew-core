class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.52.tar.gz"
  sha256 "ee79330d252ca60dcc2207bdcb35f68f857bf78f884d44392e4c7ec2a54559ee"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b84608182222359b36bdbdc6a4ca1891f09ca7bf5113732004e51c4ea1d6e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ffb8407c23da9a5850517575151c43fb9750ca7c3059b8488ab6acbf0c15e0"
    sha256 cellar: :any_skip_relocation, monterey:       "50987ccc2944eaeb2119de825f7af87b6f9eaf88e91b25dcd1c5634de0447a37"
    sha256 cellar: :any_skip_relocation, big_sur:        "1edf820f1f756091a4828bc9bd9c09360033004c4bce7e88d09fd94bc322d0f4"
    sha256 cellar: :any_skip_relocation, catalina:       "530af09c0a685aad6348cf5e5ccbc47bdd0b2c24165b35397c545cbb3f7ead34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc06ac39edb89e8aa8a0fffd8a9984328b5fefe1bcec82c8d909107ba03bf35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
