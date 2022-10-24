class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.42.tar.gz"
  sha256 "a391467a36334e141e8a2a633b064a5a6b0f0f2341a324e9e319ba350142a61c"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d835ec801fcdd7e8a22d674efe14661d294e0b096a6ed1d8b305c0e5cb169d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c59d371b0a97745785e69566b8ece91313859190fbca72187ac5121bcdd58ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "55fb2bd8fa048b24264aa7b9c669d0f3b580ce9cb8bc759183342199f5eea8fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "96c8ede4918ab484222910b02a1cf7b4246865f5941478e17db59446a08dd25e"
    sha256 cellar: :any_skip_relocation, catalina:       "4af2e17971c5287f1eba9b81ce2ba990a09a63121ba391a0f51bcd33b6b630b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e438b3d3d96f3d761e20710529fb062d010de7c94a22f4e0657458c5050f89"
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
