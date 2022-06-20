class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.16.tar.gz"
  sha256 "8404877ed6319b07f876cdc265ba28961ebe9ac91f15a9b8e5b43c98bf668f40"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6d2540b439ac6ccd834ff6c11b26bdeff4185bf752c3ad478c90276e7f31eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25f51079d070ef504f5bb7aac7cad96b60b8cd8fba1b9a291a72f5df0fb6aac2"
    sha256 cellar: :any_skip_relocation, monterey:       "fc24491126d3a53915b92896d5b42d824ced43687813df9c0c6b2d0012b632a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fc251b0f3dfeb4094ee211b9f40b5a6bcd9ad1b64f9e3eab517672d4f8d04f1"
    sha256 cellar: :any_skip_relocation, catalina:       "ad739df42d36f28351372eddee99409f6a9a7e9521f7866f89c5230b664455d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823698403e96df57d43554c63466cdadcbfaa938f75215951d0ba230c4ae7f61"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
