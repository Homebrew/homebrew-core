class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.6.tar.gz"
  sha256 "02fa03778b05b782dbe4e2334b755277e308842c57936ed111b341e1c1030ee6"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9566c6669102b6f48179842316b8483a0c1395a7d40f607bdefc88ae8f6413d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a0bcb0bf21fdb4dade177370a686d0ab83c515ebeeb951de59013eb3b115d8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ac5f339a49914245cffb045e560a84c35b9d7806f1bfda40cda66bbc5ffe11"
    sha256 cellar: :any_skip_relocation, sonoma:         "72a9115a41cb68058049f018ed4564418305d9fe4634586d92975cb0122e04f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b768c11ad7496b0af4ab6e050d4f31845ab97d6ceddecb42ae41d9bba47f6e"
    sha256 cellar: :any_skip_relocation, monterey:       "98d69b0e56dd8bebefdecfe2556e8abb10fc14a1e00fa33249680738ec841f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a46f727031db8b03a7f91c7a55dce631a7a57c9bdf01de2e6e6e9bfa54f470c0"
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
