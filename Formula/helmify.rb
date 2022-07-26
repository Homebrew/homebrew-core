class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.18",
      revision: "13d7c886579bb702fc9e710281c06db30800ace9"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70fc0f08908d9de948a8999991281c085b687d12b348c38ca54d69fa774853a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00671e85f60e9259bfac8f2bbaab04e3c86cb926bd242927d7e45fac25182d50"
    sha256 cellar: :any_skip_relocation, monterey:       "86f4ab628135acabd46c18456347363c0fe125ed682468ad4d2eb94bb2a78a39"
    sha256 cellar: :any_skip_relocation, big_sur:        "52acc5a42769825d44b68f119d79d93753c7ff4a52db21d47e70ef8eb8fcc1d9"
    sha256 cellar: :any_skip_relocation, catalina:       "f2ff05fa018a337c62068c52c9b337189d3fcc82b0998a841cd3f2c041c0bbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6947a2ba458476686f715af3f7d1591fba0dca70ac2ac4f3cf60a0ea60b693e"
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
