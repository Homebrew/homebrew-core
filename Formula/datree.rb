class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.70.tar.gz"
  sha256 "6507e7d49a61ca967d4eaf80c4406c7bf5de3053e9bb1ea63421c7e13055001a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8740ba01ce370bfa52fa93ea5a5c2b131174b2f663719f344134faf153882dab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e138a2dfeadb84606528a9607b6f69a98a6875a02c5c90df8d3d52f70ed544f"
    sha256 cellar: :any_skip_relocation, monterey:       "02331c2abff6252e02e9e7d2be758d5785fdf3e6cdced567fc40e5a68e73682d"
    sha256 cellar: :any_skip_relocation, big_sur:        "11eeba8b4d94d781e04c451e4f201524dc6d5b141568a36509ad3f1fbd2d0af5"
    sha256 cellar: :any_skip_relocation, catalina:       "a6194de24a4c76790239519c39446b5cb41c1995336fe8b87e3307e942516236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90950f26330d5ddee65a70bad68aa114d30b82e3109869f13cc41820a5056f87"
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
