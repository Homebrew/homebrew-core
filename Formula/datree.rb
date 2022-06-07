class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.2.tar.gz"
  sha256 "697004ab0dc312ce45243280e45e0780f9a0f98973be0ec78c17ab4f93e8ac12"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5032d926908af30fcf7fd1461e7f11fe69934f45a12618df0e70ee43e1bd282d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c109a6300b45ac8006f65af93e60131c240ee85278f91de552b0156c38bde70"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2ae8c071fc387e59087fc26a2d87c934caece05ef1bf344190e1b3034005ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa1f1b5ee499f64d64a739bf6b3308474b3085c27b1ff3ade1b2de694c64cbbe"
    sha256 cellar: :any_skip_relocation, catalina:       "e79e0a86f2284fef99b944e0d6dec8731fc253c37afe3a627416b4e621ad8bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a95fc9c09a46ab9e9ba95029b858341a628cd542de297cced89d56e853a6a0c"
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
