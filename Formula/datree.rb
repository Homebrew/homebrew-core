class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.65.tar.gz"
  sha256 "e2eed84c1ac7427cd7d2b933f7e9572383305e9cbfe160977aa0140344df9880"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bf4e7611201c4890821c65a7474e4c64c9a9673548ec4663345185994996b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9bd0da0ca0daae4b4a0fc3d30303a461e744c1e3a4530c0e988f5d9d27bd9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89eabd38d6d0a0b05410b3191f85120ceaf0465f2b2fccc9ffc5dad395c12b94"
    sha256 cellar: :any_skip_relocation, ventura:        "f931dfd2e67de5279fc066ace37cdf3294a879b7a7030f0391067ec07c3531a6"
    sha256 cellar: :any_skip_relocation, monterey:       "af36c303e655ade4c74938c1f3a3de118d0c332c01279903eb9149d874bf5a1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b678dcb01d374f42e5a9d3e185db921ce6f6d57ea4892fb3b26d80b48397ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d788be8eb9a7c231c8ed2f1c3a272cbe2155f15de7edc43c71bf018961dd9e84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
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
