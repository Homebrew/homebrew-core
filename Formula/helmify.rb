class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.26",
      revision: "3b265bdd81ce3a245405c0e69e55087fbe6539e0"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a86e9417740d822f90ccf195fd2f0142480007d350b80fc0cb39ea5ef840fa98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e31c9a4ae5aa2f358bd3ea77ae98e844efac5c186e4f31b0c6971e34652b33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a567dd0b2e11c64acb1b7a92ed9c201a6ff07b920211eb4cd0e75503bb5cd05"
    sha256 cellar: :any_skip_relocation, ventura:        "b6ad585a7c360a0899243fff5611b184cd66363cb41048c941627bb0d16c5c31"
    sha256 cellar: :any_skip_relocation, monterey:       "089cb03c08e1f4923ccb4d6b30de49fd939315e7ffa21dc29400822d54849c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2e294c243a1ddad2424433055a5f00d044f4c4e9e9191a6cff6c00c8b21cc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da94bc66970bf46247fd737995421c284b1bcd400c762bf6c1c0f48ec3f6e43"
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
