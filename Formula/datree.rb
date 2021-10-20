class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.4.tar.gz"
  sha256 "d05dbf1a6caafefc5f5efea411e52baa303ca11ac38f922c1342f6d5c9be401b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b508a1bc7275330e7f7667240df06683c0c683fa6bb80a7a17e6ca640821ac9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c12425e964bdff81050de1421b438ca7047c0d9cc4bf43dd6fa9e06ee2df45ad"
    sha256 cellar: :any_skip_relocation, catalina:      "4a652b3f22e646bbfd9951a0a62dbd9190213a8206cba8777393181a4ea7b2dc"
    sha256 cellar: :any_skip_relocation, mojave:        "0a8500388f465534278278b5b034f00adf07b7aaab4b95505ee3bd52e3c9b8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfee3a783bfd9569498cc8c3a73fc56b3d0a528c4658dd027b7544cf6f0dde9c"
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
