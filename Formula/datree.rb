class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.35.tar.gz"
  sha256 "9530a0e6307f0dea6ec07186a51bfc967e24886ed7888e3ed0391227e4e059dd"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1dcb1036df70e0f7e9b3619d70586099fc876265fc049327160b0fee1e2ec19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71fda43152901fefdea0dd4e746fc3cd5dc5bc4b74afcef8ded299d5c4de5c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "0502467cd1acb6e5a7f58e594979e42b9898a2838815a1af32bdcf5e453f82ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd817a86f999c23c081b613087fb388f12812632ed3cae5fe674a721eba27b3d"
    sha256 cellar: :any_skip_relocation, catalina:       "8bf5685872cca45e624f1d9f372af8b64337150b4a117347de42fb270b375a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2babc6fab2789d233cc87e705957836e622299e495b26895a5d92d6b2e49ed2"
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
