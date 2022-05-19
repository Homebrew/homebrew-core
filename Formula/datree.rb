class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.26.tar.gz"
  sha256 "826f465d2dc16fa43c0a5d587196217207f9a05c13b42d04465487d15a73654f"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03dffc2f2a6493183ff0ac442e076be74cb811fca8d32bdd6fbe05aec7e9f008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4be5996eccbae30e32c8b3d060a8d5324e0ac6e9070ed6306f1fdd3f760c90f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f1e5a1a5d1a97822eb02fe4545a34dd7d5cb8ca25d56f5e87a20dbb267bc12"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c0997e18bc5311ad9194fff20be75355924d04b1065125af43f95e208d5cc98"
    sha256 cellar: :any_skip_relocation, catalina:       "6ba8787bc8dae2f7f4c580f5fe5f354b42d27a31d78651fd395902e17de4e3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af13a7caf16abe0b1c9a0f747cf3b1d631840acd2c9bb4cd2e5530c3926cf6e8"
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
