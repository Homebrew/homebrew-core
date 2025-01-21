class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.23.tar.gz"
  sha256 "a0464981234670738e0a997b25f34faae0b68134b2c3dab381141010ced140c3"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f64fbd2843f5d14ffc388ae24540e2eb25215cf9d8a22087403bf4fdf318d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fa3276e0f03316e5a31deff5b37971607693eefc96eb1d50d571979439d80cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9fee69b8f3965a0774418ace5216c7914093e141db04755226082a6b8a93029"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d688a25336fe3b0181a891ff6b1d225379ff7f4ea621cba69cc89dff2f276d2"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b3b71f3790b792ad17f0fccb870892e9d87832e5dcda8615f10d027fec3706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1d90d0f092be3644c53328750a9a585ec15959664b53afd50e8337d0d9281ac"
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

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
