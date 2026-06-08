class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "488a53df69685f5bd6a39de166ce9509fb3b5c4eca660b570c3e40c3946cf17c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ec3a2e375b0680248926ceae7ce3a62ece31d91f9c4a1567d489e111380e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "365c14c6cb05b9eb584c0b8609cd7cf97a163472269b01ee4fda5b7082922dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3bc1eff4e41d17760222f1b8c38afac6188987c5bf12eeeddec0fbab87fe66"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee0442ca001960088dd7e588eb5a4defff09f62de7011cfe2238ab98398a538e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe57781c328b462925ce385e38b1dc7fc908b006bfba274c91f341ab099cfd06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "239f92e5da47427006cb77afa522a8f2cdc89c875946137016c57728dc66f175"
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
