class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.101.tar.gz"
  sha256 "1f76d7126070985fca61127ae66a5f5ec681cf6c51b150e6c4fa1b876a82351c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44270a35a08391d2104b2ec483587d6cd067ea48c2030dd6e6fc9919ff9d0e42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d56a5276c8b2129131678013500928faf58c3b55450784e6331f56ba0460c308"
    sha256 cellar: :any_skip_relocation, monterey:       "92181547babc3ee0a75e2cbb86109c56f1d1093ea5374164822eb41d46a1b8e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "68c55bfff96e56d53b2588479f2f69c308438e9412a2ea3ede560e62a2dbe09a"
    sha256 cellar: :any_skip_relocation, catalina:       "902971af56cdd94944067882da08d3027121d40302cfe7a9cd3959ed72b84c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8702d056ca5cf01f5ccd0d87b839256cab3232582c002ccc103c92c45053c6"
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
