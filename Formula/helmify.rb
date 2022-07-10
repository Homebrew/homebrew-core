class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.17",
      revision: "011c7794c8a3f3bfcee4cd32faafe7648c0b8ead"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07d7a28b6973b5203ca79a2e37f7b91bcb8d4b7004167bef89bca377dab212d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1db57aa056fb6aa82d76261ae5abdbaafdd0446a2c90406b740f257bf2e5e06"
    sha256 cellar: :any_skip_relocation, monterey:       "e538269879d1ca172a68c48bd85cb29996ce2aa2b7c8a687d03f1926e19f8245"
    sha256 cellar: :any_skip_relocation, big_sur:        "78ea6c9faf8fe605d92f1f841d196f6f4f38b37dd1ee24f38e84d179acacbdc7"
    sha256 cellar: :any_skip_relocation, catalina:       "2ccd6e52006646b55fd0080349596b5d74824cc5235a8394884488d2f04c667f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "063a3d120f29185062157d361eee3f2b15bfefb46eecdee02c0d72773b7907d1"
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
