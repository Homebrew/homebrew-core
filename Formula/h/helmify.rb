class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.5",
      revision: "e6af99e5738ee4dbe42a4cc4c1b9fcd1d3734a88"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a680ff660fd46441bf65b6f7f83739598b774cd6a74f54265cccf3caf6f64a5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a680ff660fd46441bf65b6f7f83739598b774cd6a74f54265cccf3caf6f64a5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a680ff660fd46441bf65b6f7f83739598b774cd6a74f54265cccf3caf6f64a5d"
    sha256 cellar: :any_skip_relocation, ventura:        "84c0a4d1d8502ad2416896924aa87848b7d46fee2bb23131f00ff3d1094a4def"
    sha256 cellar: :any_skip_relocation, monterey:       "84c0a4d1d8502ad2416896924aa87848b7d46fee2bb23131f00ff3d1094a4def"
    sha256 cellar: :any_skip_relocation, big_sur:        "84c0a4d1d8502ad2416896924aa87848b7d46fee2bb23131f00ff3d1094a4def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c146f86bd90b627e812a78e6419a600c8efe17f7bec002927df1b63c0f6033"
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
