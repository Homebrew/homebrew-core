class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.40.tar.gz"
  sha256 "b684da78cf4491c385ee4d53f5e14eeec3e2cfb89a47c13f0829e04c4298122a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b835bf0127642e8bb53d4a96ef0ba9a39f6c5c56598d9622c5144fc48877ba63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1275a1ad0431f2a3e738eafd1a702b06542fb998c01ab7b3a70127c377beaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "ee23a9ca1be648393a791970d9b67e9b4427a655e5cd65458c69a627d5b1c512"
    sha256 cellar: :any_skip_relocation, big_sur:        "7406efcb9223669b9f6818044c9026a72446d8c0b9a3524aa0e0f9b45975f235"
    sha256 cellar: :any_skip_relocation, catalina:       "d721ad36617d43ec3275ad85408a11153c1c98f4a6bbb48c7d55235dc6050052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48a656f6bf31f9e6925a386ef470668a5714b3ebfa45402d13c5d6dc355f40ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
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
