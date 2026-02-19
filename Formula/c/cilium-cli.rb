class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "ff611f8a2347b768c7dd8955839b55f07d165d8d2dbf642309842fbf812b3ea9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c70194f507ded93184235845d65af768e02f85ce17aa9a6a1cd30983d58d264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2017e5177d026515a69e32e2cadbace6c169b23cfd1db092f440c3daa6042cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2237cdf259f003a1be164be7dc11de4853bafbee102c49df0c744d6274b2343c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a4956db54a88851b0379f68f35c418df7e44235507ae63491fb49fbe2706f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5b0b0be4812af4ab00a797b30ad49e699b8884f5cf9e11ed096bf57fcd92f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9658269088cbd2dc5303962b52167acfa3b8b4b4a50550809c80bc0c0b2e0ab1"
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
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
