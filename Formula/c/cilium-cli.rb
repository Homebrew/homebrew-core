class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "edc3109e365494e801fc752a5e52e3e2290153bccab2e96cc62df828bf87f289"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1957a62416f2a6cf4b62f9ae09a191239056426e89f5028a27a2a38678eb3289"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c78afe2c6b713bb7cb6fe0e16b9ea1faad76596b500808965f8f57af5c5fb2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4825e7a272ccff2ad4a537c35c083a84321725743dad8772555aa92067062525"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd7c558b3359fbf0c8e5de605405abb59820c4ebbde59ee6ce746ee8af26d05"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3a99056788e8b47a0ffc98108f0afbbecc2898c045dd325ffe1f4fd106cc9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e5129226c261d44341c156de68b82880787e68127c22e34d5df54544e1283a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3406db7226e0b52928b66b06fa22ef476e5276bfba9ddbce1c3bd9bf44660b12"
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
