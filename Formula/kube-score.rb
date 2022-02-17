class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.14.0",
      revision: "3d6392471f65c47a1c617d78d9f84a53457c5f5d"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d65ca4f637272e9c26f9488c34f06ae1f97f09207899f6afe38cb0db4eaf91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9263d0aeab0f5ee03f541dd149669a3d227e92305735c37f89322d8ccfbcbd82"
    sha256 cellar: :any_skip_relocation, monterey:       "db28c4baa1d32c6688288f002c735c64f39433a6ab010d5c05ec3036b919417f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a2c2f4a974e02af3a7bbbf2ec80931860d8581f3fe2c74ea79b9706664785fe"
    sha256 cellar: :any_skip_relocation, catalina:       "051dd60d5d5e40cdf7cf9a1d26e3ea8d735bff0faa1a300dd373e92c73a26494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd66fefdb488875005d4f2e998084569e534b60e0ceba45add602bf5f6d897d9"
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
