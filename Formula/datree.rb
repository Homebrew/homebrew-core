class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.26.tar.gz"
  sha256 "d7db966a8fe8eae594c5b1208cf36402194f4ca10cdb6dbb9dd074528cccd90a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7cd5e46a712b3db8d0769ef2c32dbecb949cba78cac08fa325fa8514c09c11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22d747f63f1c150cfcd14042ede84e403a40a917529b0d9dd79a3de765ab97ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f52359c256495cef957b16c57fb0dc1c629cf3d0ed085a0b1ce57ac7079f1a27"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd68d30d3139e6061ee112762d499c7f092d0c1ee605379277809a884af8125"
    sha256 cellar: :any_skip_relocation, catalina:       "999de7851e908c999abdcb52f9a71cf288a07d6702879597545f41aa33643a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2158cf4dc8e43da14be7199f566052391c9bd4101363f43cd56a402e7ba892"
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
