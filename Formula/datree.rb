class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.20.tar.gz"
  sha256 "6c8b860fae29049f80f0bf1ad9a7c055b0f475e4ada268748963d04a4285cbff"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d13db5b0d5adf551ff78fb7a97ff588eeb7134d535d98932fdad063d7504a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a89eef1e4f7a74772d5e49cce3a7b45b5c5dd71f9300ec7c7019a176e8eaaa"
    sha256 cellar: :any_skip_relocation, monterey:       "1705e511c611555fd245ce95b2c062a56ea65b8a0c0f272840569cef174567e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6357cb591a57a826ea28d093509614221d656e8f96a37952dc9fcb60d387c39a"
    sha256 cellar: :any_skip_relocation, catalina:       "b899bc1ca5f4730b7cd98ee0411b9398e229a2568ae10abc91f8eb82152aac28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae6a315b81871865c3de7979a8b8cd650a3c00ca6c1da2bde7e17bf7343e080"
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
