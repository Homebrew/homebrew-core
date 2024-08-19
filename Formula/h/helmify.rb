class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "58966064b53e8bcb34f2dabd616167cfa165c379d37f3990cd1e22b7761cf8c0"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3303c7b48a28061701c67de18bd4e780d43ad5987f08d05eb434d5c4fb91748"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d528070a542a797538cf2000c0532a3154b85a3ba8acd14d042da734bb2261de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b8ba85ed92d797334334eac8ef30316af4945168e8c87f3b52b473414ff8ba5"
    sha256 cellar: :any_skip_relocation, sonoma:         "db57b71e16430a9b0fcc8f27aeec61657255233a192c625d7510aa17cccf2ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "7031af1bee9903587e8eb86a6c5047862ea80fcbabb21e83cc5fa9c88a89e716"
    sha256 cellar: :any_skip_relocation, monterey:       "498a0217f5e5ebdac5f6959e96b0b81f00768f2789ee5fbe8c88abad1570b8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3fe00fe873102c22fcd78d4f9ff498b581e21fdfaf99066fd1e59df1ed0e822"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmify"
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
