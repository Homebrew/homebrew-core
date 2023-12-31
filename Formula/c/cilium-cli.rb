class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.19.tar.gz"
  sha256 "f5f79256ae447e09e65ed848179f221a1a4e938f85ba111485af2ea83362bfd0"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e466ca899728e5bd51e144f292baf89b565c8b2d4cf64caf68da894eb481f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94af1afd750c04559f0d433c77a0e80973b74a027bccbeafdf6cc7af1903bfad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "683d6fd72838f67ad8c6e6dceed2b1595d0e4feb08a720a1943da12f9030e4b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f78303fbc77d9746b2a1954b16a1ba61a561041ebbe52b7ee3819e5612a0388"
    sha256 cellar: :any_skip_relocation, ventura:        "bbce9a15c8d7c672a2661009dce0466209705336644b2f34ae48814b82635ed6"
    sha256 cellar: :any_skip_relocation, monterey:       "6454dc09b1e74af0b2d7950fc939f667c388a2830e50a81f899bf3ef2714a1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79dfc346a8b0f19adb3f8f5207cc449f0a3818f33add292d6565e40e94b50698"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
