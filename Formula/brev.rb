class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.167.tar.gz"
  sha256 "e3a5342aadcee1813a84ab991e8b6999c252bedc1da2e29171865d1b2576a097"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cdfd24758bda54e03fdb21ee8c0aa0976c415cace844a1c85136c1a2bafa33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e79320cfe7b07fdf958a7ab8a1ac7dc98b5df5ae6c10190b3e603c14e813369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e97272f87e4e777ae92fa85b1ce616328849c932a67ec24a4c3f384a71737860"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f7cce39b0d83dead1c9c89d4081f6fb1983e048816f9d1b89673fd2673d221"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac5464b9a52fbc1f6f65c5848bdb4c379381f41a7366db7e73ccd434fbe3c71"
    sha256 cellar: :any_skip_relocation, catalina:       "b03c4dbc5400ebd213be2f8282fa67f36f7e73c190fcbf73f6bbfa979f4c827d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447a7d9a5e3066fa9e4f7640b462c65cfb9dbad38056aaf34ca9749228408cc7"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
