class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.18",
      revision: "13d7c886579bb702fc9e710281c06db30800ace9"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6bb4f8b23d0d0599db25cc8ff8a05076e7c825a176e88a4b1ba20ab508d657f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56371bbf7545036d83b7d6c2da4caef6dbf23e25d8579c41f86eba4f72ed8949"
    sha256 cellar: :any_skip_relocation, monterey:       "b51afa95b7047718aae8b73cdb2fd86665f18c67560dfeda486d76479a20b676"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e58b84cc234731806da2d3b677d04f84d90fab126fd7e9324d4510e7200d871"
    sha256 cellar: :any_skip_relocation, catalina:       "58321a4febb76b550746fdbe17504961d16995ae5cd7157e982201d76b224724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac877fe73c7851970d47f55efb58c1eb8c44253ede8498a6424310d7daa4078"
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
