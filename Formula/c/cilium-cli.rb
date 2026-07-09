class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "12ca7462d43c0dd174939edb792c05ad65fc42f5e70ee9d0083c91c2fea1fd78"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24f3224651fe35ab94166ae7caef401c4cc1f2fbd97e248147f03c7003980149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0d75d8e9c449a1908dbcec7f6ec68db3b31329c53fb1edfbb93c4017db3784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e65336efc2be0f886518398194e9dbaf7dab1ee1fa3d361c7657b6e6879c840"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db0a7261a6bdeef24f07d405d5aafa43c2f1c320f040ac0bf909a862da9eddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddb93bb1caea2d56987b3c08ce4cffd44089fb7959e06e378f5367db2404c19d"
    sha256 cellar: :any,                 x86_64_linux:  "58b589acc395296822584f8ca2bd6be6bdfab54dd22d7f7b2e84219b017f2eea"
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
