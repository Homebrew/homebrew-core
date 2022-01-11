class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.95.tar.gz"
  sha256 "3f8e313826d54994debf15399084afc229677858a1cedf5397955f0cea2efd5d"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8814d27bf5f8ff114430be22cfc2125c57004c83be0a569b61d9718023d36f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd738bf643e22ff8383da1644d4ddd60a814b24e507c3d4266784901907d3731"
    sha256 cellar: :any_skip_relocation, monterey:       "f94ac10aa3d20d3c2ea04f6d7b306589976c23e620c5f7fc90e4989f9ec5cbbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df7e69e317c271607fcabf2a4ddf675933428b2ad2529d3aceffcbe41edca36"
    sha256 cellar: :any_skip_relocation, catalina:       "37257afc72f4c8cbca45d155156dadbf62d98cdfd354baef2b1a00273cf51118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d2837419ea9e86e44796a1b623b49fa73ece7b0ca985cee0cd8d023ffd8fef"
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
