class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.9.tar.gz"
  sha256 "9efe00f3203f3bd864eb36b4f08c75a31c17f37c8e33e4b4f595bc4222a9781f"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "600348af979ee32092ba272da55f36869033e275e0161de3ac23f1db1a8dd8f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df85e34a38306c9d3c44096f58507a2ea5379ff2338abc34d2d5f498dbba2d65"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9df7cc468a62b284c72be152eb2f698353b3f7892c1a31466928776b1efc82"
    sha256 cellar: :any_skip_relocation, big_sur:        "de45e50489fb2ef4b06e20c85044d7ca206145b50199b4fb54c771f424f7daf0"
    sha256 cellar: :any_skip_relocation, catalina:       "489b9b586e5304076acd02a55505c53f0948f1ddf87b95850c103fb61d89d686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "602f26f24c5e114a3d67d08d3a65d2b26f96ea5ddbe0c44e72d7808fd85baefd"
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
