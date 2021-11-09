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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5890800f7595f651a55916702b82da172743e183420a7ff021c38c3c781cdd66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c2a9e5c462bf4c351ad6726505ff412ea87e828e08d9cf2cbc34f634367b54e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6cf50ee9fa69d83d74bba045cb35a587847030414955a3f83a6bec90d4f8fb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a87ad1f648f3aeb0b592577d401cd96d98c683793874f26f21dadb6b26042a8"
    sha256 cellar: :any_skip_relocation, catalina:       "18daf16729ec84d3c8c40e63968f554838f1c5ce05cc7a7a87b4fbae5ff7aa20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b83bc4ab7113d6af3fff9d0729afbb85864f86a9b36cb23ba4720a264fccd67"
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
