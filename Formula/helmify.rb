class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.29",
      revision: "81ba5a2d3ef3bb3967995ed85ac8d97d6c008817"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5421b1c9c51d78fa29a6250c7c851492d147cc35e22d8c37031ece8b7e1d90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5421b1c9c51d78fa29a6250c7c851492d147cc35e22d8c37031ece8b7e1d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa5421b1c9c51d78fa29a6250c7c851492d147cc35e22d8c37031ece8b7e1d90"
    sha256 cellar: :any_skip_relocation, ventura:        "f620f694fd0be8dbc5d161dcb72144cec7121d920c2fb03d5d8f8c7453942c68"
    sha256 cellar: :any_skip_relocation, monterey:       "f620f694fd0be8dbc5d161dcb72144cec7121d920c2fb03d5d8f8c7453942c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "f620f694fd0be8dbc5d161dcb72144cec7121d920c2fb03d5d8f8c7453942c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201b0a4d7730685002f4ed2542fd0ea42815a02a21bf9cfd449fd96176b46ec2"
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
