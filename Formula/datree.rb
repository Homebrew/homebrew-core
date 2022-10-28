class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.46.tar.gz"
  sha256 "68d104a3c244307f40ad26128a910f76ae549d2f776817280473b3f8128a7650"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1864ec9b46901fe61bbed6771f653eba558bc173531f27c021283cdeba7d3af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "453ce1a838d5bf0c4774bc04a0389abb8c38979ff6ef43e5492b60a340a297b2"
    sha256 cellar: :any_skip_relocation, monterey:       "80a879ac3f18f8e75a8121a667fc9c715db0a62cf967041ddbf1024d6ee3cbad"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bfcc1884bc0e62fe9369e1a4bf9c04cbb18b088db3d6b4270d8704b6d947431"
    sha256 cellar: :any_skip_relocation, catalina:       "d069cadc1560fd96e7cc380120aa6a07f3094b2d8632f94dbeb04904fae8fe78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc427ef8fb3f392f34dec3660b05ffac05cd49234f5622a12715e05c5927e925"
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
