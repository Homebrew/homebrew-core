class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.16.1",
      revision: "74e551f58e9009e70012773a68dcd6424cf6379d"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5118de22a69b64ff4a850b732cb53d574225a0d48cbc95eeb69e0ef2bb52c005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2130a7a8053bba23d497b77ae755e9914e806356e9342c88145ccfbe7b09763"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3aac121fc19f8da33c66a1ce65dfb8a8362657c5b31bb13b8da750de8df5c49"
    sha256 cellar: :any_skip_relocation, ventura:        "44cdaf3ce7b4d35676e01e61e3d1bd111f78d47fd07810c4d8ebfc189a960233"
    sha256 cellar: :any_skip_relocation, monterey:       "a3ca528ec01a7e19db86f048658075234c44aaa7edac85d526eea4be353c57c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1652bbb31eb182a869e1a0e7e329306c73b3d4db7969b68f190747bbf22b9266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77cb8748f33179b1b4cae8306afe6d53828d0da47539c40e915e547609bca2db"
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
