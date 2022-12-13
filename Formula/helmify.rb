class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.20",
      revision: "3325f461b324165880208634cab47ddef2a456ae"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7840be03887eb95c075526ccc514072c57334cd95e72cd5155c04dc02ac4937e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ce70b00ef3d181d01d74139c63f67d4e4f77fff3e0dd9b6eadc7a00a90cfe7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c43befe06a24e7e2ca1e899bd277a2c112b0c8a2cdb81ed8eb712898ab0d7059"
    sha256 cellar: :any_skip_relocation, ventura:        "1b4579ea24328adf844bff422dd17006c827531f3503fa8197dc33886c077988"
    sha256 cellar: :any_skip_relocation, monterey:       "97b1195cf5e2461366d078b9d2cfd7599956fca1ad049f8f69818cad6c942b2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4016cea7abfc5cbfcbeadd53b89d60021a0f3a29125f0659c107c52733dfaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228ea8ecc10f2caba3defd50eaa72aedb990078a42d5877520ecd4630480347f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
