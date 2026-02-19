class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "526fbe17c7b07855a64f2cdc205536c5de5a3864e2c43b626aaa53e07ec292a7"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e7489c80e3820f0dd456260f83b29abb95cc7684eb74dfc9c72892d918290a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e7489c80e3820f0dd456260f83b29abb95cc7684eb74dfc9c72892d918290a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e7489c80e3820f0dd456260f83b29abb95cc7684eb74dfc9c72892d918290a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cd19644c74e50e066676ee9d00ae93d6a524a6e5e71acf0ac43b1f687721c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3835eb3ce418633949cc359652f8d645c2d0e7a910d3287627b82c88dcf0bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9274e1af015e3bbacde8a4bb7bdceab4712ba9a9405834407c1308e29bd09a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML

    expected_values_yaml = <<~YAML
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    YAML

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_path_exists testpath/"brewtest/Chart.yaml"
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
