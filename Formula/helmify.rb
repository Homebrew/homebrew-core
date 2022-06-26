class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.13",
      revision: "f96b7aede441a03b6da20d1c09efe6055046b51d"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "643eed3d48ac4b22fea2c92f45e1d246e58c0b9e3ce3207035ee6321e5a73327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b3c432acbf2002f55e01a97896f7c42cdf86b6e8ff07bdf46cb4d85d050d16e"
    sha256 cellar: :any_skip_relocation, monterey:       "e19798b0feed40368127bedd58404c8a6a7e5cfce949c2c38609eb2b203e2a63"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0a381f606960de3462de66e746990aa6f65c1d04b008adb830066a66145920"
    sha256 cellar: :any_skip_relocation, catalina:       "60856b6382dd86c84f9177a513aa4b57de028a6aeebd76abfd1c731b04d7ddcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47b3bef45543611f2b8a13a0e4a1ae2a5ebfd9178b179703afeeefc8aa9dccc"
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
