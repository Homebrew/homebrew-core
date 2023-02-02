class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.23",
      revision: "a5edb18a2ecced632c9396613fd4c1166c7ce79e"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5007b7c0e90bf1cf280625949d7bd0d115a4ed92407b47b51137ab81ca1e71b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4de0ea3c4c623fc45329c369d2081790c4227cb6f4a0dc2ecf541b4da827148c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e80a94f241fdf98e6182d24cff2eeb3d61cc93e7596833c2abe6d6be4bb380e"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba0d63932bf8a012f705e579b131169c5c51b145797773588b01ed637aa787e"
    sha256 cellar: :any_skip_relocation, monterey:       "92136bf2cf9d40f3edf88fb85ceac6a4faf4ae99c3d75a95b8a03a18a7fd3a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "1deea9cb78852a834749de9aca9966d87b6c6edbcf77148eaa7f1db2247b5933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad780211087d2c66129ea2da6b8b3f740d28c45f19e6643df4b20624adee097"
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
