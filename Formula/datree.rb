class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.26.tar.gz"
  sha256 "826f465d2dc16fa43c0a5d587196217207f9a05c13b42d04465487d15a73654f"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d5db5adc3b693bfaea0b50d57082f3329408e6c322c93b47819ba12b8cda6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332437e1ce447d87649c5fe7d597b1d98ceb8bd22bb1087db3b1b51bd8bfeba2"
    sha256 cellar: :any_skip_relocation, monterey:       "f38399777588a20ebec34563d8a877d3436af2ab0948dea971a8d2489d6bff50"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e213fde3a4710f78f90f9777bf7802fd9a0326af4c8f2dd78190afac8de95cc"
    sha256 cellar: :any_skip_relocation, catalina:       "af441b4a371ed844e4441e1a2d82ac167d654f2a813a36cabf6ca07b90521d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec76bbe89242e0f512648ac1449971aaa9c1c5e76c24c0c8290787c7a5063e04"
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
