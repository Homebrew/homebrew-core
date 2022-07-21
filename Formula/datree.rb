class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.36.tar.gz"
  sha256 "7aff0fe96b12ef782228207ee86a06da7044c83c96ff5f3af1d2da48e09bc737"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c771017c523a8b7fedd3ee09809e07ebc56f1a0576f8766dbe09f888ac3f6a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd9cc534f35ff504118d112b1a2ed748c3f8ab9b43a7c363bf76ab4eb56b9ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1ecd66029ecdc3ab6726f0064603e6d94b100813bf1a57a1f321c9d49a2e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd0e6a90b8029b81f41edbae903b3d15bf5abe9cf92485e1a5c61222e1c1b315"
    sha256 cellar: :any_skip_relocation, catalina:       "93ac28f83634cefacdbe7e421fb32402e235a1c1ab5358edd6fae0f3c59d76d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437d7dac19ca05ed1906f3f74c3166685bfce0c6e24c59afc5b4d0035090eb7c"
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
