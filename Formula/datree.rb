class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.7.3.tar.gz"
  sha256 "9555f89e2937f459c1130a263f9cf2b0bad18586718fe97adde36c2187b81098"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ee66ace6986aa260d86cad889f911de50101de7187c0cbff72b83fad40b6537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2ef4f870cb491f4caafd178fadf0436467a6304a98a97c0373ad0fb89ec109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad8da30ada8ab5a88d3477f1cdfc51580784b9dc1143b67a44b9865fd41137c"
    sha256 cellar: :any_skip_relocation, monterey:       "4220c122bd0f2f87ab50ae9ef89f1811fa439c31a8f02b851d0682f444f7b43c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9f886775fb715508478875fb1175a4bee568c7fbeeb79c3b79901b065db046"
    sha256 cellar: :any_skip_relocation, catalina:       "0fe8a164d86e664c5e8486266f5facaa970a435038dd34eb844ce7fa4fb2c691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de29f714d37591a0b59c38c1d66a1fc56cef81a2166fbaf7140c44c30e059d15"
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
