class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.20.0",
      revision: "81371e9f53b633bec69423fc298295bd71bd869a"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f56227624dd0d4980bddcaa35592e0848a44dced318dcb595838eec62bf8b835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c59a7d469dad58f1fa600c7e28fd9355ea66991c5c96921c72408eb631c8823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c59a7d469dad58f1fa600c7e28fd9355ea66991c5c96921c72408eb631c8823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c59a7d469dad58f1fa600c7e28fd9355ea66991c5c96921c72408eb631c8823"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6eef05adc999c965abb8fbfe2e87845b4ae9dcd48109648350823fb755c861"
    sha256 cellar: :any_skip_relocation, ventura:       "5c6eef05adc999c965abb8fbfe2e87845b4ae9dcd48109648350823fb755c861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8264d94b19a2eb76c3e07f8dfb29ea87127d0941c5d3bb53bea0202b93ebc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f6522e699234368ab760c7c0f55b66cb5fa9c020c923d9656248c56de0e169"
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
