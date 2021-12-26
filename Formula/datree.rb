class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.87.tar.gz"
  sha256 "9f789c18869818fe1a563f1803a65c030f936284f3609a20206b745cc507ba2d"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a60d06b6b65b9a07599affc6d84bc7264971ef43610811d14bee3766265f856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f4ddf6e467e7c56841e0fdafc77ecd76015ac52e42431029054706c003b38e2"
    sha256 cellar: :any_skip_relocation, monterey:       "d94402996566b3edd9f7f65a4eea93f5d5b9ce9e974001dac658ac37d5280eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8039f4f2ccebd27cc90329c40bc203e99f344a6fe02afee2371bdfed71293d9e"
    sha256 cellar: :any_skip_relocation, catalina:       "a25ad4aec3368648f8b6fc9044f65c0c5cfe6afe3ab7372ea46b7fcec527a2ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91193826241113ad6f1f58ca7ed7e74ea0a7334aa9024f01257db59f4c0c4750"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
