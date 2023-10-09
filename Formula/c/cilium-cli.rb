class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.10.tar.gz"
  sha256 "6883b57615a990c990ca9974404df49c549c9ca5615be2b0ce257c5b5e861748"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fd484975182d60bd5280abb05034166f66b128c4730b5802a45dfb47ea4e985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94d31c918a605e2472763149c458707202ce42222fe1f8f438f1ce02409c5892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb02695c7068f1e0c616863c5cb650de0c08d8a19615438c225f76d0a0e34ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dded0e71f3756ac8133c0fc3a3f27f7106618e255320e3631c37156b3e69a60"
    sha256 cellar: :any_skip_relocation, ventura:        "2b4d6326b02c39c27b42de620df383566a56277b2fc113a0095b5d38a6700af6"
    sha256 cellar: :any_skip_relocation, monterey:       "f21068f1215390d2e010524d5ee12983cf48c276d5a295ba288ab6e9da4ed3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde00167101d888a9e12c9fa7592eb21e83af22c3e5f2a10aae6bec196baade9"
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
