class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.45.tar.gz"
  sha256 "b39c36f7e0730555dc1b854dfdc813e31d2608d2b99ba10e04f11bbeef9154d3"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1001d00613b7274f750fe465f1597caf7f3dd29d63724baf974c04d52d5da4e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eac24f856a9c204ee13055ab12d12312259540c1b3c1eec7d462bee8c85aa78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f37616f2e62d9d1a723de0d19f0d9f651cc19e1cdebe7fd75e9cfe36fb82f5cb"
    sha256 cellar: :any_skip_relocation, ventura:        "caa0ec8455139fa24491f29adb46a045bb731b556e140c3c1c2becf7fd90d03b"
    sha256 cellar: :any_skip_relocation, monterey:       "92ee4f28525844d1fdf9c5f2887de6b59a43208984676e962f90d77e38f9781c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fed9a46cd601b7c2455aa846102e4f5bce2df1cade45986b572fefebc686008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef67ef7186959d2aaa3c6a5c96b50d25b5281e668a2ec582b1d8af8012e58473"
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
