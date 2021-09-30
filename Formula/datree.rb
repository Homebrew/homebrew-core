class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.13.4.tar.gz"
  sha256 "93bb75897c54df83717b1c80a7340ae195f5156c63027200ca1db8f9983d9bbf"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c83b1d5fd12077532814e9e9021d7b28fcb2f77156e45820dee0e4834bc81e24"
    sha256 cellar: :any_skip_relocation, big_sur:       "afa387c8292972702a679104afe2c39568f73f3d1abe21aaf5df3497b6229848"
    sha256 cellar: :any_skip_relocation, catalina:      "1fcab71a883d0d8d7bcbaf17a3e079b206a26c34cfe74894afbb97f8bf2591bf"
    sha256 cellar: :any_skip_relocation, mojave:        "bbf8c9af7515a9fe0399b58619c71bde5425aee4c21c8e6dd22b5ed6501b3f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c77bd344f87cc3bf41def32e10a746080be408f80266770ed12abe3c765d62"
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
