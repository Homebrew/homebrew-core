class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.33.tar.gz"
  sha256 "54c9085ca42a18b4a17df8a5897ed3456a71f4a7f0accedfc0284cedbdb323d1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5384255b75a0f47709e2b66cd52938bc50dcc74d34f4dc389d3a8ff46476fd28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36808573679a2942c570e68ad0d0d95e1045e67fc53215c53b389b77eb46f7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "f0afdd58a4e8130ad5e3d9c1391004bf6e336c78bd9b6a73db0e55d3e4b5f17b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7effebefc28a603a7ec50535e032f4cbd7ce04e62a6e3b9d554583dbd880e753"
    sha256 cellar: :any_skip_relocation, catalina:       "679c26eaf79ff6edebd72b897e913fe2c377d30cb6118a58a157180a5e1b6723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354f6c10c7732a0b1be52ac71068412f11731149d284c8032a9f5b384572f54c"
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
