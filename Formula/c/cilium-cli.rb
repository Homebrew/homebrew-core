class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "8bc461a4401a370e646431e336f595fcbb4de67fb1f4421ff62dcb7e65aa0321"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54eba32d3d61fd60049204b95b7ff9af619c662b509a9c93b5678d499fb95bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14753fa7919582262483e59d3136ade3085a8be53c11dd0d480e61839063eea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "370205fc6b8cd62d261fc437aec4a09462c8cde7266d299c1f6496e82a4e9187"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6a2820b9d2f7624108d07036300e28994101eac65c5362cd21855d4a9c41ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1b32d342ea69ccfe10e83e9269a939eb38a1bd2ec6b850e08f0f2ec66fc1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f690811ae700c1272ef28a56c8ccd973b7b163106ebd7ea1ae087b397432ae2d"
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

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
