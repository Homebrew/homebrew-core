class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.0.tar.gz"
  sha256 "6fe351177d6799df092cee0180c231dd894b939e5b4bab1aad0447d7dcde8a21"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "972a2d99108a5bfcfbaa3e20297f6e063172bcfa7960fa4010eb2446fab7682b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be796e48ada760663d2c9e2ff6d25f8ff4da57c86949297cd1692e936db6bb80"
    sha256 cellar: :any_skip_relocation, monterey:       "c7edf3bbce4bf010e29f86581a712dba208848fa45039ea2ebf515c55d3c0c14"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a85a17b824b73cc25611fd93323a1c1403d26bb9c31b9a8f0871f25d1175b79"
    sha256 cellar: :any_skip_relocation, catalina:       "e591056fc03ffa45fed804aa7f48e04eb238b16b14091ba6e8743fbafc3ea31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70bde36ee033593d544f38d897409298914d89e2acb8d6b513858d6b333ea16"
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
