class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.17.0",
      revision: "0b3f154ca3f06a13323431a7d2199a74a1869fbc"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b765da9a1434f1de7a612bae28b6a7e4c45b0a416ec1035b36e769b25846063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d49a76e867e9a5dfa6b38a0185042688f5caf38d6cb774b074e901ebf3b6ad15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49a76e867e9a5dfa6b38a0185042688f5caf38d6cb774b074e901ebf3b6ad15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d49a76e867e9a5dfa6b38a0185042688f5caf38d6cb774b074e901ebf3b6ad15"
    sha256 cellar: :any_skip_relocation, sonoma:         "c708aa75ca0c9b15afc82b01a306ff107257c51cdfb0f7c3fc45c4429b8519f8"
    sha256 cellar: :any_skip_relocation, ventura:        "b78dcbef67b48e688d354b718ed6db212f447b158fe86a633bf250bda3d61d22"
    sha256 cellar: :any_skip_relocation, monterey:       "b78dcbef67b48e688d354b718ed6db212f447b158fe86a633bf250bda3d61d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "b78dcbef67b48e688d354b718ed6db212f447b158fe86a633bf250bda3d61d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e8db51267850718bd4f6bee0dd2fbc85b4810bad8511a1c9b4f8460db329de6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
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
