class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.16.1",
      revision: "74e551f58e9009e70012773a68dcd6424cf6379d"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d10bf43d8ac528b0b1e0e06c670b50ab8adb292b00c7563c96ff1fd12a19d5e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d8bd96147a1992cf190638c2c27e7fe00aba320d24d0717a3d22246cf810b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4849155072342e0724ba5c5ef0b4489108d73b1c6a8bdea4915e541f1aa6df0"
    sha256 cellar: :any_skip_relocation, ventura:        "df2f8f24f27b38d2ad1aca18f4909490887ff9071c0684b6d5a1c4eed63a9d63"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff38e9009444bad8d934afd1eae6d59a3f8495a1fcd8a4569d1adc889f09a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ecd00ff81d5cfd885383968c54a473cd7b07d1d3a40a45c97d0e0e91043aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cebd82d5b852d1d581cbcab128e0b426b5e95f203eab12d11462e406d32844"
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
