class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "87a2d8c67c6349c5395550723158074750e33bce08391e30b47625457ec92278"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f495c01123fd2d5e4545c71374bc80d74a34a9ffbc8f9593602620a35fc0a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03636e503e9d1493204807ede18277887e366bf63a395e0ea46342fd0f344916"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d2c61ddf7245906c8dcc35e898d69131de5013d6d7fcdb3c3e85b591e2a9217"
    sha256 cellar: :any_skip_relocation, sonoma:        "658b1a4f1a4a4f9648c4f3897f8d8c33251e322134e69c2809b6700a340a4b70"
    sha256 cellar: :any_skip_relocation, ventura:       "00ccf0145218e4fdd4349ab1fd2f5783085f2c24e896476920aba1e0db26ccea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b0a6514593122a8dc05da2c20de674894cdbd19faaee01e0f3799a59ec3573f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bb98eee5ede9f1829a3f15d7d74a6af2045d799c752d9e110971b42c91df24"
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
