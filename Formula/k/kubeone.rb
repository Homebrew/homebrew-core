class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "420b7d729702617e2c6070aafd280843af3d58f3be025fe743f49b16454f582b"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f71aa0773e287d37e6358557347b087e4c076e6dc51ae960f47b68e41097d5b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1d3a0285b51d0587dcfad8cb1ee9c28a210f69644322889f9b3461ff018bb56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9814456c1cdb322f3eb8604a49a435783b356a6173bdfe9c0b68d2680633bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d2ab730f99b33d6aeb203027be9032460388fe6be896b8d3cdd8a7895efe25d"
    sha256 cellar: :any,                 x86_64_linux:      "144802e69e18d9731882f025c28b8796eb7d0c285213cf492a90dd078139dcc2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end
