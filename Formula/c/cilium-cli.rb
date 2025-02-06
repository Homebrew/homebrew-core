class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.24.tar.gz"
  sha256 "d7eb7e8e3b904e131c48d9e0aec09d3a5dc4a98d6fe78d5d9aa222565e2a69f9"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a8083640072d02e452bb88b0ebff12a87ec4f33965db934d777936f7f5b3a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a96562cd49af2a56c7d369bd5198b24dc64dd140647b2ff26bbb64285ecd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "983cd80b5b86a09767568c4aabb6aafd041220de11b96cb9e60917dafabb8b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "104db2aab0c548c675d93a9f322aaade1e9cf29564b1e5348054960d4fa09fb9"
    sha256 cellar: :any_skip_relocation, ventura:       "0da5efdf4a757cd27408e381e31cf0afd6e5479d7134ac51e67cd2679bb7d6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bb4b4dee58e47eb076f1593ca8538c43e7355b15ccf873e3c07431ffb9543b"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https://raw.githubusercontent.com/cilium/cilium/main/stable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
      -X github.com/cilium/cilium/cilium-cli/defaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
