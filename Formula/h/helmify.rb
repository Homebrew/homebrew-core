class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.20.tar.gz"
  sha256 "34febd73d083e119cadc0a880152ea4802396e59fe09bf5243ab440f5a54be91"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c365d7f2c270924290922374c61da69d6728d6c1ba78196220a40b88fe590105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c365d7f2c270924290922374c61da69d6728d6c1ba78196220a40b88fe590105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c365d7f2c270924290922374c61da69d6728d6c1ba78196220a40b88fe590105"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad5b9ca6f9a28f8dcd881cb32b33071c70627659afdbc44ed9d649cc32c58f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8dbcac6adca92486861d58bb289f1f88e551413ef4fe3788eba02756fa06412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459f71a7f76dbf6ef0e2459a78299187bc90ce04d63b2bc51af75f54d9303857"
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
