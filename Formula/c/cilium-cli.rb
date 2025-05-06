class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "f66a555a1b55af77c61d9a38621316b84d574d9a621efd04bbbde410f99b4ae0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e74d6ea9956e95d89e3384682679af1b96e0358ab05f4aaabf93a2d75164c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2990e6ef7a9c49562409c766eb881ec5facf007d0096e34bccc06ad66e497b14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b46b628eed28e362be48dbf29fa2154f2073cd31dfe9f9f7e8bdb8d482cad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcb89cf4ab90049871bbe6938c6b8eb48517e8a207a949211ff5f29442e808a"
    sha256 cellar: :any_skip_relocation, ventura:       "38b4ccc078a072a8d2d5b0a29b024ea544a3e327b3a48b93e29b2dd70bbc8ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94cca51653b4a338b8e81b6129d00dd9464c8a1b35873551619d51aad590020b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc5dd25ff5e099e77e85c8923c9138f22751ae545027fe80876bc40fd731d24"
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
