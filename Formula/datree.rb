class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.24.tar.gz"
  sha256 "93b63a69b5bb1bdc5b9062c8f2e611fd9ec6a192c10f3aa5abadbd70d542a98b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "814123cdc94f2b78ef4b63ca6e89caeaf9702b286aa1820896b4929a4e311f48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de7cb8ea699c5e25d6fc00a4f1426a4c3dd6b90f05e4f734d34ffb970bacd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ed2c0bc0dde3ee365f6cd62cc7c2057bea73021331d905fdfaf159108011015"
    sha256 cellar: :any_skip_relocation, ventura:        "9e58c114537221fc39fd35035466381af584ca9da2c27cd8c0b06fb3a7be4f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a11132954ff3f05da6d2ce5159ca2235330eb92a2de0a5da517ee3690960cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "09884d6049c6eb5857cc3683026f34cf17430126a34fa2a040394d660e07e3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6614a7b2a2dd24362459a36686df72d495b6093bdae590f703374abd01f01757"
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
