class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.26.tar.gz"
  sha256 "dfaa3f9e0424e72bbbd0ef48dc5847d40519b17ff2543f1abcfd805863095b03"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "815e88db4824422a62742814e4a993b7cb7b45f0608a97dd49c7f4290d6cb758"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47cfd6256c89f19ad8df64bf58097b21e61df1b6eecd3e13b3708d4e9d9edcc0"
    sha256 cellar: :any_skip_relocation, monterey:       "8682b52611cf62358920e18caa49f281dd115e1a58190ea66943316aa1b89d77"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7af74a8749bec3e7934ec10738fbef5f5118bd9bcd7c9d8831ae8a1cccaa2f3"
    sha256 cellar: :any_skip_relocation, catalina:       "05b71c4b828b6442882c3af1ca371c98a1eea12bfa90c2e24f5876793e92fe1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87bfc3f1a67ee69fd560d4c6e7d2123a3bc187464324e91bc890fd6e2398ae3d"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
