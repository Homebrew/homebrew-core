class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.16.tar.gz"
  sha256 "025934c204667f4dcd1e130e62e5e32cb710577173f4a4801fca7c279170efe1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fbfc05767b69e5808370f1c58c59a279052adf8340a10f7bd20c3b16851e07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee983027d0a7ec1bbdb720a74cea33723396d7f01853d352fb467e094acf68da"
    sha256 cellar: :any_skip_relocation, monterey:       "920c1bfb223f3b88e2182b1268c0c82cc5261ceac9f06b864c043934c88e8757"
    sha256 cellar: :any_skip_relocation, big_sur:        "b002b7a78d2dc20f27497c002e461db70952beb3c568199b4ceed08fb4b7a951"
    sha256 cellar: :any_skip_relocation, catalina:       "48673cd92c888f0b9f63bf7afd250042c98defba9877cf09b4e1fcde6b467d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c3e099b4c84e3da67f767676bdc6fa23a8d4183fc43247b795c7b85bca058d"
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
