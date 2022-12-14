class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.21",
      revision: "6cb59e43918162f6d02d4e67016b79c914fcb2dc"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d7282af569a01b3e993d8c9529115fff9b0fe7edd30e9cffa5db37a2f9fd1a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32cbbabc1303dc5d1ff4b38ff545e345a5e4de63b9a95fcd04bb81279399471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "105282452a95582a5312b8ef4be0478d657f84c5b15dea06352514f3e09bb865"
    sha256 cellar: :any_skip_relocation, ventura:        "b26826e014314199c452536c3b7872f2bb8ad7a047bae765ce4f7fb31563fe47"
    sha256 cellar: :any_skip_relocation, monterey:       "9caa8e2905ad8752ab4fc689839b628badddc52b94eb16b1f90a4c2c1c16684a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b1e3ff8c1a34f4f63f3219b377f734c1939ef13c5739741434ee0ad5e0b073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aace2ce2afb107b1c182a825d87f6fdda19c79738997e2c3138fe4ff70a7c9c"
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
