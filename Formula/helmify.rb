class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.33",
      revision: "f9a41896286bb996f954e2bcf1641ec04d2d0745"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bf4217200bd9f2a5606f0e4dad7171b53a2f0fdcdc5d0009967dc12444a6a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf4217200bd9f2a5606f0e4dad7171b53a2f0fdcdc5d0009967dc12444a6a03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bf4217200bd9f2a5606f0e4dad7171b53a2f0fdcdc5d0009967dc12444a6a03"
    sha256 cellar: :any_skip_relocation, ventura:        "12d0e4aac4946b8e842ad05f107ef7f63490393f001f26cceafdc533901aa374"
    sha256 cellar: :any_skip_relocation, monterey:       "12d0e4aac4946b8e842ad05f107ef7f63490393f001f26cceafdc533901aa374"
    sha256 cellar: :any_skip_relocation, big_sur:        "12d0e4aac4946b8e842ad05f107ef7f63490393f001f26cceafdc533901aa374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26f71a67d409e2bb7722a1fee5b2694c460e08a567764bc7a837f50a91a7eaf"
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
