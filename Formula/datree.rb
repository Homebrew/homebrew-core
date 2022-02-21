class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.21.tar.gz"
  sha256 "11d42ea51c71e30c3912941518be1b78b6a64ab66a306f7b54a874b1357b4ecd"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f6f0e13bc745a12bffaf8d3e75fbe306afe059504d697dc89971315279e6b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b774c62d4b9769a2c9be469cfabc3f8c377c3f011e4840a80f6a53a3360214b"
    sha256 cellar: :any_skip_relocation, monterey:       "acb3983b72834878f1506ad27d5fc4ef6307d2617058795770fbe9416b01ccad"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efc627f5e58641451cef214fcfa170919cb9fe91ecb5d047d2f2a611d5e0ded"
    sha256 cellar: :any_skip_relocation, catalina:       "e4b2e1c6d13020dc138d2ab055588bcb3204d1b2d1fc9e542f8ad43a34e4a4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a14f5f851ef587837cbfae86a092d1dfd6b0e321bf1090b0abc04fa98e4080b"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 2)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
