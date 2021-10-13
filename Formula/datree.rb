class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.13.7.tar.gz"
  sha256 "ba69135e4c3f4931f3195e53d19761fd30b48575a9ee14b305cf1083afe61d17"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5190af02daf66f2044017c15ec5a083b73714af919924c77058c8beebba92081"
    sha256 cellar: :any_skip_relocation, big_sur:       "56c1031e00fa417f8d0564fafac4d2a7d14c50f55564921f2b11c1e6b291da55"
    sha256 cellar: :any_skip_relocation, catalina:      "cccdae4dbb2419ceea715cf1ed74fa0fe8cf78ddb2019e6e59bf43bbf35e4be4"
    sha256 cellar: :any_skip_relocation, mojave:        "99f0ec88b113755f0653bc10a29cbe40f00581837471d4315f2c02c0e0a6e396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "088fea2ad1024af97e8df43606616835d562b915dbaf7d3913f38e0ac1de6c3f"
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
