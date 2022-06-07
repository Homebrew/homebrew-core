class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.3.tar.gz"
  sha256 "bd0e12fa4fb9b85582e0e39afa72b6576a17527268bbe0ba02fb79472f67b434"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd7d02a680c12e026afa454f581ef108329da3ba95adc2564797585d5795b2a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d55db87cd2528e15986d13b3651d358020d997ee520657a24e05788e962cef"
    sha256 cellar: :any_skip_relocation, monterey:       "7b74d0a974fde0f087b2f53f1826ed87dd34b5106232f40337bbe905e0735cb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1627a25a69a4da648ace50434df4f8716477311fc760ce6a7ef54ee2c84a65"
    sha256 cellar: :any_skip_relocation, catalina:       "a2383589cc7a0d52bcec205b6ded1bcbd2bbea41aa028a46ea0570df492fed2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88538067b5778de08b334694866167ea0f1f47eaf96535a039e64d0b7c1324e"
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
