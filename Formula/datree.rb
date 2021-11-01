class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.29.tar.gz"
  sha256 "c8ca0d03628176ab94095a44bd38b808ddb29b7792b744a7483d67c424c2d1f9"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3574dc5acce4cc740429027be176cb16f411e055e460ad99ca5a7c176cba88a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb7b05c83d9ee13980824fda3474c4b9e81d2855a5796c019e253e879042f27f"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e68e53ef972b5063d6df74ec3eff3182cfe7b9e402464b3d3551a0fc3d5e73"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c9aae0df5e238cb52c95f0fb442a2e08a62aac2d6b0b902064087ed410e16e3"
    sha256 cellar: :any_skip_relocation, catalina:       "566cac765fcd755170622f8da95f16bbdd266bd84da8543dfae5fec1fade0770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a72ec1ffb4397c379a6b51d7a2097a882e04ddd473908baaf2fed443b7ef68"
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
