class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.3",
      revision: "03f8524d60a2517902506646d07cf2acac2dfa3a"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e224ce66d9e1f35e8771d55aec732dfe4279d56289d6503a47d536e014d2884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e224ce66d9e1f35e8771d55aec732dfe4279d56289d6503a47d536e014d2884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e224ce66d9e1f35e8771d55aec732dfe4279d56289d6503a47d536e014d2884"
    sha256 cellar: :any_skip_relocation, ventura:        "b5afe24eb93d1acc3bd5a65b46ef177808d4376b8040ae5ed154441ca7b336a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b5afe24eb93d1acc3bd5a65b46ef177808d4376b8040ae5ed154441ca7b336a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5afe24eb93d1acc3bd5a65b46ef177808d4376b8040ae5ed154441ca7b336a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0737e86ad4b413661d076554039f9f64d2575feb0cadea2ff88265eaa313991f"
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
