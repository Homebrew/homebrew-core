class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.13.0",
      revision: "d1ad91defc1a5814f7c7395ed64cd7039d259158"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166de56ea1b76d175c6234d6f9644c654cce58ad61767b0edf449afb6bd0aa2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14ae4f4fe357a21a85db5693502581f559e71eceb03fa8a2f3e8e383da76cb2d"
    sha256 cellar: :any_skip_relocation, monterey:       "ea6f7ba1498dad2dc4d95628fae213dd46b7d19c7d66dc358f4a794a10ed14b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "76eb89b240b58af512d99eb134d9c796cb4131c0384b5efee098408a67902e40"
    sha256 cellar: :any_skip_relocation, catalina:       "98043d871527b391420ca2b538361062decb69a22866c18f3acb5ddbdda37be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86bd5092c9c88399cf9a297c6f3cc7f7519cd3c6446daa72e1cc400a2790c6e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-score"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-score version")

    (testpath/"test.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: node-port-service-with-ignore
        namespace: foospace
        annotations:
          kube-score/ignore: service-type
      spec:
        selector:
          app: my-app
        ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
        type: NodePort
    EOS
    assert_match "The services selector does not match any pods", shell_output("#{bin}/kube-score score test.yaml", 1)
  end
end
