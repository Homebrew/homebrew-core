class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8a436ffcb96b932053e3d115c574fd49076b2747bf74d885b90990ab4df0940d"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb20c27f993d6d504c97155163925d7a3e17827e8745e7eed3f4258cb738a915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec559a16e2b8560d90294af0c4f0f0e91a9b6c8c1c74e13404a10d823f73f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba47adf00c8da524c9564959d49a9d07ecac074496e06521b877775a90fc366a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e162c2731fff3e1b3d449faf7caa967cd8bee7ac694be8f574766790154eb200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f3f3cb5b747f9bb08817e2db5b983c7691a8d095793f1527fbc25a507b221d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5ea375526ce5f9523e1c8c900ff3d194246a4b337e4b3b01e121c930627c17"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
