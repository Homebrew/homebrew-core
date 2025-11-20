class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "fbd0d4e20e10280cbfd94b52c34451cbddc79d39098d219685b46565eeaacd33"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f1ad4fe99f0db3b7a55a3dc0c6960df36c930249bb173ef5c6cd3e9ac404d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea7feec4179ab1be8ba3fc575a1ed2b2684f81f36bb16ce6262f22e455e043c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e4dff7371fc951d677f1119e983ce4fccc4992318fd64f6d5fa5b3a9a35d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d0a3151767cd9bcc71fa3cf31be3b146bcaa5f39f805c92fe2ca9a1c38c087b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d93503a969c05a21bb0769013821eada73cc1222556bdeda72d884039524b825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1ee65b1d69eeb8de16caed9b4023bf2b0f6924e3d754ec522ad9929367c60b"
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
