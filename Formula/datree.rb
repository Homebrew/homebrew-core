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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66dca9c75d84b4408797f23fb7cfc890691cfb977259e81c6fd0fe981f6a7f7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b1d7aaec94a2e7d50867b16e971e3b759bd5ae22cec9cedf77949ade70cc733"
    sha256 cellar: :any_skip_relocation, catalina:      "cff7d17ab5f9c44d88581ac2789523304d5674c1050a259a239203c3b16d9c2a"
    sha256 cellar: :any_skip_relocation, mojave:        "4e2b4698d964066a8537bf8a6e12a08936e2ef7ac085ee761aa13f813274af17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5413210a60b88a860a42acf440db2f26e8d9e11588e23d34e7a454363a908b68"
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
