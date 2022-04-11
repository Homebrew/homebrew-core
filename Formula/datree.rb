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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c2f54a6a35259d56826312c6e49623925ca36cc09aeed6b541f23bb91a5fcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f0f19befb562df4fd0d8f5b4e9732e10537ea0573cda978389a22c60a2a0477"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b4df75a0a0641138ee336b5618b02b5b853f9202ac0dbacdb19f4635b50c3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f03ad58582e57f18f047b4b3b4922c5ac83e2f5621e04943c9cb890fc7ab0a78"
    sha256 cellar: :any_skip_relocation, catalina:       "536369de079f79c6f306a4412f00102180d08c362614f143047767e2bbe6a4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3f1defbc938faac36f4d9a7155fcc47efae222364d5a6372c93e56980c1a59"
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
