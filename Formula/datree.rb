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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc347628734b9c07ac2110d0127fef27a78f0fd5d8876d67921a30a1707e1d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "142a00f1bf9ce7bf7741382fdde035d3782e072ea6fc33a1909c6af0fb4b47f6"
    sha256 cellar: :any_skip_relocation, monterey:       "c5f1f5bef3b6185f48bc314e5f09fc08169f51986a4e6e0e063b81942580185c"
    sha256 cellar: :any_skip_relocation, big_sur:        "21fd8fa274d2e48799adf69495cdc73d536ac429fe2c1a7995430af5828e2b4b"
    sha256 cellar: :any_skip_relocation, catalina:       "d14771e2a21f49c19f8577645b8a1bc32d7eabb91ecbb410f9888011b201f8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d1debc109f98ee4beccaade5dc630bda745982a9fe6e1f1500f4c925b43ec1"
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
