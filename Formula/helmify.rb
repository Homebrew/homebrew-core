class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.16",
      revision: "b2e160a921268331544e98dfeaaa8c4a8d6775df"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5c6f8f1d045fcffb5b561622b0eb54235482a770c1ceb5ee008e5ba4c26929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077de0586c4f433ecf8cf80b754a80f7681f63e9feeae82b4f9e2c2f462dbbe6"
    sha256 cellar: :any_skip_relocation, monterey:       "713dca03a842e9d73efd709b980b954115a8fc01d2dcba976f4da2f58c3a3405"
    sha256 cellar: :any_skip_relocation, big_sur:        "0377307cd191c04aabe756b502f6f000564230b90d610d5bbac79c356eb2ddac"
    sha256 cellar: :any_skip_relocation, catalina:       "078d3497d765eccb1ad90d1835163b7a57dde943bb7f3a8d3df5759607f9f557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d021d127a0d7fecde5c5e27456feecff9f9999622bdde232255e41857a39e5"
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
