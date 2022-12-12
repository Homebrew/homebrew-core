class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.16.0",
      revision: "e30a088ffd4a16c1e7466870db4fb099a73d22fd"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee178a1e1073d8b972e5ca8b2a81630a7fdd1a700c438a3a28387809e51298f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0998cdbd0025ec9f89ffb9ea03b7d85146019c7d05636caa04079840110759d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9541bea8004aa70783f0fdf7daa8fd2efac46212b7946a526231e1344afe146c"
    sha256 cellar: :any_skip_relocation, ventura:        "33e0d6d33b2df01d680253df8eeb219118f765ee2ea17a9451e3144ec4dfd884"
    sha256 cellar: :any_skip_relocation, monterey:       "6d65b528a25ccaf73bb0b64a1b336c0bf0d7126ed54dce5741e11975c617bd36"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeff01e0c37ecf85071d6512db00b84e39874b77fa14c8390cd6c41e29582349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f1b18df82f3dfacc0f93b6d02a735c54486a3d11858c01c83d21d289b5a9627"
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
