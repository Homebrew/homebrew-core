class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.95.tar.gz"
  sha256 "ea6f182177edf3cc52aae8883b85706f50fd1c294b12455ab82162ec02d90ceb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a403afc61c506dd3f9cdf207f7241fbd23ba5e076a6c5a748065b34ff74aa6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02c94db57105281cf2e47d50888722169d16e5674531c8b636d383b39c54eba2"
    sha256 cellar: :any_skip_relocation, monterey:       "00c2a89cf8d68d4f593ba728a1a4015ccc20fbc5c50e36c769a0f7bb2ea76acb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ef37bd0948d2752a5aa0420d12a35b0fcc4e7f200a5a5786be66c0878e0158"
    sha256 cellar: :any_skip_relocation, catalina:       "908fea80ecdc27348d26acc0a5f258909dbce230894cbae60a68c2f195ad5698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b6cc41ae840b65f2e50bb03d41f9bb65f425758603b3b6a92bce33f74879fb"
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
