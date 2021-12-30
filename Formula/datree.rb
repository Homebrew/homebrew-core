class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.87.tar.gz"
  sha256 "9f789c18869818fe1a563f1803a65c030f936284f3609a20206b745cc507ba2d"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ba9b6dc98c04c3e62d11c2870307858ee0cab39387022809532fbdd9cb3e21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d6f8e582d5f6b0fcb9e1d6a411f5d04a9aa8d07b5e2346cde1ed5a0edcfa840"
    sha256 cellar: :any_skip_relocation, monterey:       "53ed8c99672cf2d11315f38b3362b41d93be838d3205a13c578953b5dee540c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7d550ab76dfdda13ed8b2b20b11b5139faa39421700c54ec4a42b274a296be"
    sha256 cellar: :any_skip_relocation, catalina:       "8f9b85ed86eb03b3543ce99ef7eda2638f75393909cff35055e859d4ca83240a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e40e87e60bb380176aa9bab971b614339e89a5350f76fa9cf6464284ec6c9e9f"
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
