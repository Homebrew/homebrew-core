class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.52.tar.gz"
  sha256 "00f99cf86ef12333e168c685d405d3667c636761c4d9ca3752af3740e5e61831"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ed314ad55ba0bfe66857102095216d4b7c8201519b9ea0dbeb610f2be6432f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7c31b7b52458f1ed6d724e69b258b758f7a5864fc182914e56d9d276dd6d099"
    sha256 cellar: :any_skip_relocation, monterey:       "68eb4a94ef4ca97ee342c851da0942a7896b5b8236085c110602d62ffd226d9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "89d4ec492dc3654c603f7c1f69533839cc5f09c091eb05d499df8a19f14cda55"
    sha256 cellar: :any_skip_relocation, catalina:       "1963f21c02f3b97fa11cad29ca85d39afbae3bf603274e4cfdec0801eaca46d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa6a58698bcfc8163f9bf9acef14c0b2c75cf020fa379d83cb822cabe91749b"
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
