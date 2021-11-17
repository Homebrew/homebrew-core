class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.49.tar.gz"
  sha256 "2c0734038f5b6af8dcdae9bc89423e7e4bea271cb9cbdd817176428118a45231"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6830755674045f6e9abe5f2144f0f4b5d8accdcb2e852f0a0d053fcc4f0aeb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f090cee3c75cc3e3f81fcf00cf03ae40b6d4d4da40ca4971049346843cd34bb"
    sha256 cellar: :any_skip_relocation, monterey:       "824942a1c55d8072dd729c6e5b419b2fdb0d51434cb64354f68e0dad13e0a115"
    sha256 cellar: :any_skip_relocation, big_sur:        "87118f857cbce75d0350b3efe4c7b332b89704be36124eb6f52ed6c59eacf25b"
    sha256 cellar: :any_skip_relocation, catalina:       "9c3be879846a6ff2a7278f903ba2e18c00891b8cc5a374ac828ab66ea201a393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d684515c97668113c6cf5d8f3772118d0b109ca7b5ebbcd3a8455ecf737fbf"
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
