class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "61281cd7b93d6203401ad4fe5ac95ede0cb9a83900656c6ecbf48dad7bc63bd3"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc7192ca78aff74b759d7fdefcf7d7665629dc1b24a0de854838edb5118e6767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27a3ea1d7c658a9a0ae2062334c46f61c9bc0b4fd5e0e46da8248db72630886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04345b722610021c917c84fca77bc5b56de76e60567a352c564238b0c9577ee4"
    sha256 cellar: :any_skip_relocation, ventura:        "d9453fde7f3e4a15982ffbdabd3dfebf091573935d64a51036b107efafd05b83"
    sha256 cellar: :any_skip_relocation, monterey:       "6653d5b4e23b4b05bc755831cc8d5f657d0736992210e424fad3f951d3e4d6ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb63374a37ed2759d1dfdddec567719204943fd14cb84e717cb8044be8a0b4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d4facd070ac73770d749061dffdf505af9105f0adffd00beba7f78c4d19860"
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
