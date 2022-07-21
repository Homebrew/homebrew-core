class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.37.tar.gz"
  sha256 "3303c0f751e869a798464c0068b2da646cb2093b80a9d39108a915fb7ff46706"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bff3c0f064ee4ca74aa622c5ef77e857ad4aa581d54ac832d6e8c0f84b65ab6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "739180dfda3c3b1e0176be49aef924063e644bb688f390cc7af0bb2928132b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "0a2df49a01e7b14b823130fca4c705ef1ad5666c4e202f38d6c497770024acb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdc0a810973815c710841fe8f4f49034bfbbe9667cbf13136a2a4e61d61f7e0a"
    sha256 cellar: :any_skip_relocation, catalina:       "9a2aec6726f93001e87fece158ede780cf8e24163b7fd4b38e9114e1be00a26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f487641a8060cc0e5b1442800d1bf8bbcce5faa402cc36177621602adcf7698"
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
