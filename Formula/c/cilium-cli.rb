class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.8.tar.gz"
  sha256 "b9ff5e6adc6f0373cc1483deba6fb2f8313c3282abcc9073552e6faa3b25816f"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483ff7a9396c555a66bb86a997469623e681381ae10f53e6d53597057e76400b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41c0e795f757c89249d86abd7280e01988ba9b8c996e4a32c5ecf3598413848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48ae58d6a92907596490655cdb3288c3d5b9fea1acea87d6cd907129c334c9cd"
    sha256 cellar: :any_skip_relocation, ventura:        "317dbf402325231abe6c06bc26f887b78abf86559b2bae47e356845e9231128c"
    sha256 cellar: :any_skip_relocation, monterey:       "49337b2b437bad000b8c2748ca0ea3e9836445eed940452eb0d9eb1cb98bb294"
    sha256 cellar: :any_skip_relocation, big_sur:        "421e5c4d9c181d846eda5b5742ed9da7a7d997973a415fa2b1fc94900844e835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599ccdb91cbbb99400dae5d265691504cfc1e7c27504d6e0222105eff3b62682"
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
