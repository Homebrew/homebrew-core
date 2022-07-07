class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.15",
      revision: "eecc5e6fe220096d19e5a1b28ff4160e7cb7899d"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a272c9f292cfab3bce3ad0a39fc9b94433558b6f4c166d76c55e39dca30207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb9241520277235261812267031ef1676900480b62c24ca6a2a8e33b3712f141"
    sha256 cellar: :any_skip_relocation, monterey:       "fe1f494a65e92bc3d017eaff5b10137776d6e606dcf05c83247aff4192215cf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bee8dfdde8d24dc8c81762fbb9888006f8c13b63661bd1f0ed1f50f56c0f7f41"
    sha256 cellar: :any_skip_relocation, catalina:       "544250eeec671c3da49648ae34acd842669623cbf11b64dc8fe54ca9ebdfbd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b30c7637f41c5954f0814db0d649ea888b9d756764cf9adb83505e43eb99a2"
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
