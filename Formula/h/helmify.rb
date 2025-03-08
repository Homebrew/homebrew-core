class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "d5d30c59f29355d8e6f0722ea863c0e72d8958d75206d948500defa36b57d430"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9292bcbd63dec204dfdfb1ee1445c40af97365351b1013b612f7b8c2d288118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9292bcbd63dec204dfdfb1ee1445c40af97365351b1013b612f7b8c2d288118"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9292bcbd63dec204dfdfb1ee1445c40af97365351b1013b612f7b8c2d288118"
    sha256 cellar: :any_skip_relocation, sonoma:        "c879d0d8990dd78ae5719e95be9ff32ece4abfb0e0279fce0faaeebb51f19f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "c879d0d8990dd78ae5719e95be9ff32ece4abfb0e0279fce0faaeebb51f19f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664f4e993ea457c1f691ecc749086493979d37034b3cc12e589ee2bb9c4f31f2"
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
