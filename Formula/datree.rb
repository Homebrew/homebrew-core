class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.36.tar.gz"
  sha256 "27eb2cb7e4afa77de53c6095cfad4cac911ba0a27a6121007c5bf24adcc31a7b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b74654ee17c297b2ffe6fe980da69813d31da16287e23b2407fa048e73b1458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef74f33939476c0bae810f244010843ae41f77adc5dc967f872342e5c0b7a88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffe6204b9a86c2be24641b32ae36b02de0c0d9df38922015259c19017ab80011"
    sha256 cellar: :any_skip_relocation, ventura:        "5a14b9d138654cec69ccdf4a376f7bbb7bb29c115be258e8ba9f117c2981ee4f"
    sha256 cellar: :any_skip_relocation, monterey:       "35aae9ff7a24f153001edc8dfa04f1b70cff6df92d02dc9164c898c8bd54b80c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec6ddc4e2f45d0f4032d0a62fdab75ceaf5c49e86cc353fa6da8cf435d1d7f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7522fcf4205029c769f1a8a3f62e532ee432da9a5104e421e9c818b7d86248a5"
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
