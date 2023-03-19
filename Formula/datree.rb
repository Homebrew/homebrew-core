class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.45.tar.gz"
  sha256 "b39c36f7e0730555dc1b854dfdc813e31d2608d2b99ba10e04f11bbeef9154d3"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4977d2283b7d538b7fcaa1a0c047827c4bca4b14b1970ea038890944e43026"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c41b75eaf9edcb0911616a4801520ec463db9335047ecdfa119d1cefcc972cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49afd6871b0ed687708d9d367e6a201630ecc19de43ac6211d9d93e6e4dece5f"
    sha256 cellar: :any_skip_relocation, ventura:        "517d8a7abb4d2153d8af4cc39d16dfb0999ebde80265157ae7fc352a36756da1"
    sha256 cellar: :any_skip_relocation, monterey:       "9e58f523483e17fb6ff44b70d14cec2b990df12b234daa5348c88159875d2369"
    sha256 cellar: :any_skip_relocation, big_sur:        "a498380e52f144c90f5869da12edd1ec88344fbcfd6d357f37c44fd035450eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b385f12c47830a016905708928fd35e0bd6d1568720e07f1c5d9cd72e526621"
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
