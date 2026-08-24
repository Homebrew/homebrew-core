class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "24af68b7971592c95c67517d129098d2a1332bb88d64f8f1d180d07e5e4c1e8c"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3addb3af6f2574921dc5f7124903c657e622177c5f39f8a27d0ccf7fb5eef147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22625a9730f22f1e4f6b4eb3838bd800575b61721edc1ddc37ae790d209d1a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78053b6af184a209f4f6bcf466c1502a27b7eff3c660dd46b4623fd81ffac1f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cace3b1670b7a1502dc0672e5a25e17ab4c811328adde5c34f1549926388671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3b3b23ebe81ebb7de82b06515d209cb671c0af31468be4033ffd9d7592c555"
    sha256 cellar: :any,                 x86_64_linux:  "d1f1f0aa0fb03b50c413756f8804f7137fa88f86b7cfea7bdd50145935759dbb"
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
