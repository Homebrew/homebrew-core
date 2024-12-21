class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.22.tar.gz"
  sha256 "eb75b32fae3bd6f15f9bb96b1d8be319732d28f40f51afbb61bf65c72a93e176"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "060edbd99c33cafb86f4530e07bccc74c93dbc5ce4bd225f3147ba5b525e45f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3760abb21ff93ac7f972ef58ce7e0021e321c2ee95530d15332e652e10ad602e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e3a18ca016b7cec830c1675c8ffee0bf12c1c8c041f3548b9a8807d2715fd8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd5399d3a397c0539cea012804084a38f546d11220b787badcabfe9c2df9b82"
    sha256 cellar: :any_skip_relocation, ventura:       "5208c9b93830511b2be8d0e6209cb9ff1093ba418f1075cbce64816c31efc1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cbabaa2dbdb9d785f9cab541ce3a43e49963a06c2c9b0642324b1512dd8c61"
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
