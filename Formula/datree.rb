class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.29.tar.gz"
  sha256 "c4b7e663e4715df0ef1292c39ebff53ebf330a78366c435acf774b12fb94ce28"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abea23f58734a41aae3741bc6d639b967f0e3fae1959fea9dc13795dae3316e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12538b5ca3838794b9f092e46b3806be85bf7054beb008528f141e5062ec7ead"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4abdd0216353aed1ac0038ebceaa4c16829953bbb3c552da47157ab0c3a82b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb74803635e50491472184c26d45fe182185d57b25b2fac32683b272700e9ff3"
    sha256 cellar: :any_skip_relocation, catalina:       "49baf28cb4d1deeb0286784edc461f7364025f136a371b5184fd91efc9481cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e465b82ac5d194c3369b0ee1c23fe7fb49aecf4721f94e1336c2ec23b740652"
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
