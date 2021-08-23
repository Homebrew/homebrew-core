class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.7.1.tar.gz"
  sha256 "5a17495e60e7748d236af16a56485138d2e10bd769b7779033d0eb37e6f90fb7"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

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
