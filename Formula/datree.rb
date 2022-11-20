class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.1.tar.gz"
  sha256 "c144b07561949e713eae1be2eba668c0bd7f62f94a11ce34e138a8cc2d11a081"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca82193fe4049e6fbb0a51c353c33431e289e6145c58c972332039f4d352389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb66835708c0570e2da608517b3829622de4a6037fb896af1789fef64f684b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29856a35b7785911f6e317aa62871eb83a896db7f1062fd2772e6661a7a171e0"
    sha256 cellar: :any_skip_relocation, ventura:        "b58170125dc7c9a591ccb668963185074b6c408bb2500a88e540c5a3c6d775f9"
    sha256 cellar: :any_skip_relocation, monterey:       "9376132367987219513c52e64888ffabf1e8e37def7efe6c0f22437d52d6c212"
    sha256 cellar: :any_skip_relocation, big_sur:        "e08d4ce77d247b8a96d5dcc43b0f0e8040c20a6abb713d63debff1acb12b8d7e"
    sha256 cellar: :any_skip_relocation, catalina:       "0cc52826465542026dbe6c95f52ddd79a58d92670e353ea5c013f82cf7fd9b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f59c50bab9b3122e86c38f91a57b56ecf0d58a590aef31242c383a76d54a55"
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
