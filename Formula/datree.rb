class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.5.tar.gz"
  sha256 "99f7ea139fe2b1c274e1c1b34a8bbfb5cbb977cfb378b05f3fb5adcaae9d77ab"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eebae0b55f35f4f4000b75f292dc0c66a952e7317d7581f74dcee43886da3a68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad2957fdea4d94d7626adf4cbb867be7ac27a076a59410a7ef917982b326678"
    sha256 cellar: :any_skip_relocation, monterey:       "13d22e43505e6bfc6a0bb2999bb0e8a20f519380cc4c2ea9e6d4aaff1f5329e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bf86559f852a568c52b3e78fa02256035de9ba55b41d26f8fca7d290e23d78d"
    sha256 cellar: :any_skip_relocation, catalina:       "93b0e9490aa67218616ca0fb99019816533e76a42cf951c22a139aa2658e1568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3a26fa1cfc73223195fcc3e388d614c6e393f8d5c394ee0b2f555664ec29caf"
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
