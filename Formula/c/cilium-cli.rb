class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "6be3f82ded39a567852d5f28c7e1ef9b26b2b31541edb62ed0c875af793d1d61"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c91771bb10bfc79a07b71b999a8eb7a899bbdc13a2790ffb296ea70fc8fa5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f563c7afe634438f4aa7e8b40896cc5c81850854ab4cc063becee482b6b3be2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2bfc9379a28d3a5f4f541478a9ed52764eef09e22cb204bb939aeef17ebdce"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6bb909c2329e7671b67b50d5d72656562098a22b7260a7d8550195140b7928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c8d97f02695c1d37180d1d663a1fcc2897761600d38d89253dc0dfb8e9a1d73"
    sha256 cellar: :any,                 x86_64_linux:  "5d8200607e025c32601f977ea7ad02f9c3b6c77c017f1ed2c77b5369de5db5ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
