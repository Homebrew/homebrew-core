class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.16.tar.gz"
  sha256 "ec7c5da1747e159174fa9b6fc7db10f0ef06c6847e0036ff080fd478c93e2b3a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22578a5f1de7395f20a9f19d39ee67450ddd2d2f0855d50057323fd7af3b5c2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50fc42659eae3a02598abc110451168a456e750a9bf7f99f5e7daf8c74977afe"
    sha256 cellar: :any_skip_relocation, monterey:       "f771d3d0596931de920d323498047dfd5f03ed6856b24d3edc8feb882bd3f962"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2590d360033508c3e2387d4a4443a3fb20dbaedab15dea484c60c80cb473211"
    sha256 cellar: :any_skip_relocation, catalina:       "aabf477a7038d049341cbda94ab76c328b9a1566d29f0b3f29bc9c571adfdc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "150e69ab478a3814d2a1994dff610dd8c6383ed8f62c8da36d1b4692fe235799"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
