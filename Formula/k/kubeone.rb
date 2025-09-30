class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "e74475cecd62fcb7fa7d0856a809be9e16394a9ebc5b646201900e517dfd93c3"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "803f1e3d139a266a00015ec9ba8a576cc133871305c7bc0b6b0b7373ab74bafe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c772d91dd5ceb8e0fe6d4e8bb931a906208ffe778f34f027c54f126947e91ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3739cfdfbe03c306bcd81f983e3028ed9ee542b2b0a427be6d830b609e07a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "80cf9f12a59b0c2af748afcb72cdc284fdca7f50cbe5200dfc56c2f8002e50e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8344d8513ff25efeb0db278f4aa1867410f3190fed3bc10461caa9e2f95c92a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747515c0741cd1e90ec4e6dba33ea7833987f2e98640caeae0b7fe60c3bfe8a9"
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
