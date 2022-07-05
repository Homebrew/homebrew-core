class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.25.tar.gz"
  sha256 "33be8e2b84900f295d0b5eeb46edf02537cc842b9cf231510421d5616441aa72"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedb73c5d0d2eaf1a84cf54793c5ee1f6f6ecd98370ec70870779c3ac4d2b13b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67a44ea1b066cfd7dacc0ed0b0d395fdedd8b90b07ec013070947d021e2e6ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "589c6b5beaa574c24785642fc349680d24d52157d2725d8a0506462ce6a57f67"
    sha256 cellar: :any_skip_relocation, big_sur:        "f689febd68b7e4f3e908ca44833857980acb67551b8419f58995036256084b01"
    sha256 cellar: :any_skip_relocation, catalina:       "a25d4a796fcf1cab3b2ad0c19078b459593896f6d24b3d642a39ba062bafe4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ca5f2a03cb4a2b218df179ab7caea1d3b57641f5eb0a06321ac52f1c2d7176"
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
