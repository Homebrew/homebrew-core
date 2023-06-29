class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.4",
      revision: "de2e663fe7146cbb41fb2d80a610805368d5ba00"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f7df6d49acacd74789b9b3e4fa6e789c7868274cb5cb7612bfe8fbb5438b3c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f7df6d49acacd74789b9b3e4fa6e789c7868274cb5cb7612bfe8fbb5438b3c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f7df6d49acacd74789b9b3e4fa6e789c7868274cb5cb7612bfe8fbb5438b3c7"
    sha256 cellar: :any_skip_relocation, ventura:        "e711f0b0cc89ab7a41d1d1703803192b4af65543d47a345363801b3a39af4c43"
    sha256 cellar: :any_skip_relocation, monterey:       "e711f0b0cc89ab7a41d1d1703803192b4af65543d47a345363801b3a39af4c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "e711f0b0cc89ab7a41d1d1703803192b4af65543d47a345363801b3a39af4c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4cfc02a3a4e7a4fc211764574d571d2d99a418bf7f63ed67416d7a54d0faed7"
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
