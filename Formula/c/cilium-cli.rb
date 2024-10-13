class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.19.tar.gz"
  sha256 "e16441d7f6371eb31290111b23e74947c5569501d30b2299009510c3f1ad8a6f"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd892b2e392bfdba2e4ecb49c82d49dbbdf0810e9313b86746bca3e8af3a2a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15068eb79020ed2beedc8098f34855c27964e5bc3601415de6382e45a121300e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "470843c391f180df8e7fb46c965927563d9e452a2994ad0ab61fcd818c6bdd0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1729cdd952423d0265764b48b5c9c2afdfd23ddec70f2543343afadd1e23d818"
    sha256 cellar: :any_skip_relocation, ventura:       "48c231ddfc32ae50de9ab874d4396991540aec5314dab1582c652ae64d23175b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bd49c48e81819c5edcf94ebec9bd9440e5ef815a67fa7dff180d83d87f9363"
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

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
