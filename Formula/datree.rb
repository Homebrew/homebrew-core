class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.36.tar.gz"
  sha256 "817a2ed5f3e3fda5f88f2ce3c4750aad9849dc93c3073e23074fa3e83d65877c"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c459152c3efdc76493cb0cba2aabf079cb42f250b45e9058e6c31ec9d832e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbb4ec3b2a229344aebfe2928b8acf8e92334dc2d7597d77b5996b44885e48c9"
    sha256 cellar: :any_skip_relocation, monterey:       "abce76a37c5da00da18192e4ce1e57cb45f23c0c754a5a0544ad2b1a16edbd05"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ee476004b71ef2d721691663af31ba7edd405b78e0aadbfe4e51f86db92da8b"
    sha256 cellar: :any_skip_relocation, catalina:       "c7eea84c8f0a98b2bb011b8b3ed3a2df5c9cef79b330fd1c50f9f0a88935810a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ecffc3afbb1e43436d44837a0475408c66c1cf00d8f3d1cfdc3a0e73da01df0"
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
