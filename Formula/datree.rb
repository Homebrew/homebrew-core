class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.7.tar.gz"
  sha256 "2b3d931ff2601db7415e1e681d995715dd677285a5e574b6de0801844b180215"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d08254ede0423b5af460e2c1fd4bb5d5e490b4b778ef4f46af8a86327c871ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89db1c8b1de0b286a31b2e8391da3095e31974172f88c679a23fa707d9052550"
    sha256 cellar: :any_skip_relocation, monterey:       "d0765c6099d1dd0db569c70af6837b7f125d8e4e3eb797656fcaf3bb901e9678"
    sha256 cellar: :any_skip_relocation, big_sur:        "e53670263f41266e577a2bec557727000301ba69290845ae8da4cdca5a0b048f"
    sha256 cellar: :any_skip_relocation, catalina:       "e9a197adeb6d6b080fed83747dddb303aeb84c05d2275ea74efdb917b9afbd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58c1c1c4c0d4156a9f997886d17c99e5b808d6ee34ef4498785bab436acd305"
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
