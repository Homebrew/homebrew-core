class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.92.tar.gz"
  sha256 "bc0da1bc6a0d31a3b6aee4ec467940627459351f6f939ed08038f0d6e88f8750"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bccb12e2c6f324420d589b28f8825a931fc96beb48af434eb0d5053178f8d7cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706baf14aa34d8d499e14c3c4c4ed837d40ddf88bdd557143e9e5a4824df9586"
    sha256 cellar: :any_skip_relocation, monterey:       "bb93daa8c98c7e78a2f2908bea921bf9dede5ede668a208bb8c36ecd7392b20b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d1383d52520000a9412bf1b789b5c26ddd9d326d7ccbc50493ca20b78253e12"
    sha256 cellar: :any_skip_relocation, catalina:       "7dcc6191b2ec1236f26d4ac2f6b2785abb2996b3528974d1e1bc93b08879d893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfed1cd8a9d47cfdd8d5b487ce3662c07c9fbfc1d58dacc3d4a06fab80ac80be"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
