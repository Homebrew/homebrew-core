class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.31",
      revision: "76ac0d3d361669e2b4d6aad68b73fc7c0217d20d"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9caf5e167ae38a28dd325a9e4c8fbb5f2531b2f24c36c62a8188f7a2928849ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9caf5e167ae38a28dd325a9e4c8fbb5f2531b2f24c36c62a8188f7a2928849ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9caf5e167ae38a28dd325a9e4c8fbb5f2531b2f24c36c62a8188f7a2928849ec"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6f20a4746500618bcd745a099292647b9205959ce238506beca6f9baddb395"
    sha256 cellar: :any_skip_relocation, monterey:       "0d6f20a4746500618bcd745a099292647b9205959ce238506beca6f9baddb395"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d6f20a4746500618bcd745a099292647b9205959ce238506beca6f9baddb395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7be06825e517ff823110600f92a99d6a3418d7e8f52545ec945fe8409d8f162"
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
