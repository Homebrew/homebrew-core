class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "58d1cf4fc4e3327a7adf4bc9c9415161397611895a03e05bee2493410474ac16"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db94cfa5c24807e8cd3d1ae4dbdb2c6359c50b6bca65650eec092404260c4fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e9c7bf5bacdaecd50b34917d4a5f31e41762facad85668e9e7f6f6dc5c8b56d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "658d71886974c1a144c25407d0b5e2c63c2646f45451c1d9d68e995e2c36befe"
    sha256 cellar: :any_skip_relocation, sonoma:         "34b15f262dd9e2a9324d5cc9d1b7deb3b6b5d20c19961766273122b7245e4a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "fb73a8e9c88715862f6417d1e2155db2521a592753406222a1209c4a387a0e50"
    sha256 cellar: :any_skip_relocation, monterey:       "38fb4ca33469badfbcc83764628bfcb1355d5c47593f41253518249d95fc0037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63370c026b974ac28fb4b8fed2419c021d4cb8d2596767ef641415ba2f7aaef4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/defaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
