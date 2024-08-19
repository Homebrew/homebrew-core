class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.18.0",
      revision: "0fb5f668e153c22696aa75ec769b080c41b5dd3d"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e98d0912c56136708f76febcb5c21aa4120694aa176c510061ec0839382d23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e478d458c20b767beaf3450f8c0d2639aeac1f5f347b3f1da6a933c29a660e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16120280e27daad25243b31ac6852b7b0952b72e1efd690e14fd1a06849be24"
    sha256 cellar: :any_skip_relocation, sonoma:         "795074d42d93536ba29ce24b5da559113c6c2eed6a00be74b357973bdbdf0ad8"
    sha256 cellar: :any_skip_relocation, ventura:        "e42709aa48593bc08b62d2797fe5176194696228366bbf1a9bb5067711140b38"
    sha256 cellar: :any_skip_relocation, monterey:       "750a7a9aa2a6d45fd1931918e4e2853fd3e05761b92a11b43f47a272b631837c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d1502c621b5960c422725ef8ab00ead69120d9e6056431c62e5b6efd079d34"
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
