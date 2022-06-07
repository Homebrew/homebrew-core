class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.13",
      revision: "f96b7aede441a03b6da20d1c09efe6055046b51d"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef8cd4760798dc9eb966857e1c614bf91c78cfe3aafbf930a7fd4d32b30a0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e68f0e9274faf61830ebb2156f2edb3877a86e94f41d35eb77685dd2252f0bfb"
    sha256 cellar: :any_skip_relocation, monterey:       "3d615588d2f06e755cba838168270b7bf3d191cfb8353a419345df131804e40d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea7c24fd72e2022f9e371e8f2f96dd0e83a6161d38dbdf4b917639c70500e122"
    sha256 cellar: :any_skip_relocation, catalina:       "1bb265ae23580f56ff3126570ec2401e82aa4d0550cfe02a037fa7b779e98996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f485c5ce0cdce27ed86fe54a913728410245c9e49b88f7334d3a9c5968ceb6a"
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
