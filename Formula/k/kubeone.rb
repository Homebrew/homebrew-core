class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "f7614214f85da4c652e1aa6882ae9e1edae8d6d558e7eb93306dc37c2c5515c2"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fea206381ac9e6677117bfc75212d373b69792d9ba9ad5ab91cfdc39da4f054"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76d52db9b2d1f37e4a5609e1ee65db6d8fce1cd94da9f53aaa966c4755f555e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6deb54f773082e87be726b96d4187e065bbd92f68a059c429303071c8123b813"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b5d03e759a80621e8b0a43b923965790d707a7bfa40d591bcd73ea6736ca62d"
    sha256 cellar: :any,                 x86_64_linux:      "104bde5a936f63aa605f645705df0e3c7ee4fe71764832a03c60b666631d5991"
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
