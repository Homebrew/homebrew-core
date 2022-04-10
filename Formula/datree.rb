class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.2.0.tar.gz"
  sha256 "ed579d04e500b2963c627b5e03fc34f5ebca40430557d7598ff8c2fe7d42ac6f"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d681299f230b4b59ad014c7001f1804b38272a5d699d25087c55514b003a546e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef93adaf3a796154ead19278850319eed23ce86c21693957d56dd6662abd2973"
    sha256 cellar: :any_skip_relocation, monterey:       "25b5d0e1f67e4b0400416186a7a55803d40d55bfd1b315d63244ddae35af8f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e90c1155aafca0eaa6a07b1c65deb6d10f908e631f2a3aedc4ff36ee758870f"
    sha256 cellar: :any_skip_relocation, catalina:       "4367faafe4f7a7b6b67878192c9af20533c311d0cba298b30feb5fbd7a9acec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d308c0be443893c2ea0491a98f5e08d4d387a5c33eded00576c919b6640f437"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 2)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
