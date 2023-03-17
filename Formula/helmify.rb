class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.31",
      revision: "76ac0d3d361669e2b4d6aad68b73fc7c0217d20d"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74bf238b5b987f73ca9ad4db9a1dca4a815a723dac3809d8e77361d09774d4d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bf238b5b987f73ca9ad4db9a1dca4a815a723dac3809d8e77361d09774d4d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74bf238b5b987f73ca9ad4db9a1dca4a815a723dac3809d8e77361d09774d4d5"
    sha256 cellar: :any_skip_relocation, ventura:        "8285fa3afc3928bbcb609c7f1c79283ec595be2d554aadb96b85015b21bf819c"
    sha256 cellar: :any_skip_relocation, monterey:       "8285fa3afc3928bbcb609c7f1c79283ec595be2d554aadb96b85015b21bf819c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8285fa3afc3928bbcb609c7f1c79283ec595be2d554aadb96b85015b21bf819c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa593b9cb999796783a3e2dd4b4409ab81b48500a7a6cb934da3664d2ca5c2d"
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
