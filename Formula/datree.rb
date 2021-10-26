class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.17.tar.gz"
  sha256 "5c05b6bf3f5958e212f784c189f854518afc7b43b19a0258a51fb9aaa378ceae"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03d501914a90aafb1420a04d9d84dd69b27ec23f259e6cc8cf6c3eb04a6aa75d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8411d0090ccb7688425ffe96c2c8f981938a442534cf94c93b570249aca5aaf6"
    sha256 cellar: :any_skip_relocation, monterey:       "67d41c5ce0a5cdabedd1526e8685326067c59229245011d56c75652181e620f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4734fd84c45e820389dbc52f632d117540b696b051ad835c16776d7de2db257"
    sha256 cellar: :any_skip_relocation, catalina:       "2a4b463d7e08903822e772cb1af5d84841c4a8b34c75e62af3e9e8511f55cf1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768c1cc65dfc05adbd3b6a2400f53aa3e9cc72056f3c2348c24562a027e3f4ac"
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
