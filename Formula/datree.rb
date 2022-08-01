class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.0.tar.gz"
  sha256 "98b9cd8c7cd3a75b4199b6872b4dfccc025af87cfc9568c2b23eaf523dfed72a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5732ab863485eca8b7e7428323af8d0ee5e62e5feb8445e3f1d32735e7d45e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87c2de40f40362a1a6fac09fe272993525fa324a40acc6961cba53c828eaf715"
    sha256 cellar: :any_skip_relocation, monterey:       "530f6ee6704c3db10f8755d5ce586ea0a58326cc8ee8fbc63f4ed7b06bb3a70b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7ed5b33e56f6a16da005b66cb308e3b46ba69a30bb19c8685d0364761dfb9e0"
    sha256 cellar: :any_skip_relocation, catalina:       "370c4e6e3c0ac2edb5221e1dbc4765558e2428863726ee8311c441a31236434b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0346ec34a49bd429e713c869a319faece1139705a2d7224fa86f6fa02fc70cb"
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
