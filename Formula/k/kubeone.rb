class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "5dac29372ba3f093b562442b6a1730ede822e357ae78563a6b7f7eaca31ef176"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bcd393fcd6c194048a2d89f6ba13e5644ee9ea054fd7b58f97878ffab04e8e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5631283c64102907effc6fd165f37ee200fd1f66f7e4e1644982b9cc1be51dff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a5b733bcad108199ff454186127d1e6307f66ac6f29eeea34abb52660c9a0a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "769ffd0b09ae7eef2166fdb7a116f2345863fef756a52b48545f96ae962f87ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c099dd191f1ea729318691b897f49f4a15d9b92d0d3a4d9f2fc9fcbc9f0c46b4"
    sha256 cellar: :any,                 x86_64_linux:  "b439499c5746c8efe70443bef70a3ef76069973d847ae7a5cb6064fee4fb8e37"
  end

  depends_on "go" => :build

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
