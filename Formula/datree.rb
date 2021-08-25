class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.7.1.tar.gz"
  sha256 "5a17495e60e7748d236af16a56485138d2e10bd769b7779033d0eb37e6f90fb7"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f27bd61923bc32cd4009f430d339da66c3ed1e2f67e4cd280a7e7429688c56d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "937f49e642d5c7ae00bcc10229bf05597fb3283f67cb4029d11f1acb1c024838"
    sha256 cellar: :any_skip_relocation, catalina:      "0bc7e64242815f234a5d6863080c3aea5bfc10c567f4695aaf5b71e9f6dc8bb6"
    sha256 cellar: :any_skip_relocation, mojave:        "11dcd85da14660fbd59130c40d320fa1e972ad71d031f2637d29951dd2db8edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e6bf64c4a4c27777db1ceff1714ead56b146434947aa877246b5c9fadf36fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=v#{version}")
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

    assert_match "k8s schema validation error: error while parsing: missing 'apiVersion' key",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "v#{version}\n", shell_output("#{bin}/datree version")
  end
end
