class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.22.tar.gz"
  sha256 "da87699e0e8f0c66d6c0594aba921a83cc849404f2d488627dd47881d190975b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66888ab2d820c97938df55702dc7bb4cdb3ab3e674912a64f74e0c7a90721ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "822747210de89b3e818e2e17f4c4a8d5b804dc53436065e262850174dd66027a"
    sha256 cellar: :any_skip_relocation, monterey:       "cf74743418fcd96a56d73fe9b7dd5b474e7cc393eba93553123ac02c066bd669"
    sha256 cellar: :any_skip_relocation, big_sur:        "f30fb9616e9f9c4be86c5b82d57c7a3789c5b4ba985a45e1210889675ded3114"
    sha256 cellar: :any_skip_relocation, catalina:       "65ced9ad45974990c99e6693e1f97e65aeeb6969334941c24c9ca122dd9eb449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58e3b83c576ddeb9370f711f0d256c577dc5364ebd038923138fa3d0b616b22"
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
