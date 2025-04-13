class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.19.0",
      revision: "a0a0f48c808611965e2690d8af1b1d8a5415fd0b"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0983996db902e80972d36c5603393d1acbdcdb5dddc27372ca6aefc3a6bce4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0983996db902e80972d36c5603393d1acbdcdb5dddc27372ca6aefc3a6bce4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0983996db902e80972d36c5603393d1acbdcdb5dddc27372ca6aefc3a6bce4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dec538635aec13f3bfe6b3ce099865dce2e44d702a7bc8cccf2bac1a11d9546"
    sha256 cellar: :any_skip_relocation, ventura:       "6dec538635aec13f3bfe6b3ce099865dce2e44d702a7bc8cccf2bac1a11d9546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d549417ebbcbd918ee04ec73f56d0032a8bbd5909862fd3b1929ec186b224e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-score"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-score version")

    (testpath/"test.yaml").write <<~YAML
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
    YAML
    assert_match "The services selector does not match any pods", shell_output("#{bin}/kube-score score test.yaml", 1)
  end
end
