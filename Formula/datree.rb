class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.19.tar.gz"
  sha256 "00c78d6d44ac2e6c312d62310ef489489554185132cde2c6dbab79c181ffdd5e"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4566adc673d0b4bf10c9bb181e9c61e484d71682e651753dcf5b9be9fe1295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3be36f0766694eb5516f56c58253b84c9c2c08cdacd30f311c3e747fe1bd3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ff8329215e2117ed9fd114fb0bea514383963bcac3d15306e39186fe418777"
    sha256 cellar: :any_skip_relocation, big_sur:        "e738698f0484bf587ea05923ca9350b74c19c7c174df866b9ffea09efaeb805a"
    sha256 cellar: :any_skip_relocation, catalina:       "6a19c46fd9dfe4cb46dbaad7f0f572398ae9ba477f62af4e3a148d15ec1e9fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4155361d93a3bf953fc44e981572b2bf297ac46d59e3fc0ef6498ab8e884df7d"
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
