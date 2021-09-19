class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.13.0.tar.gz"
  sha256 "798aab78f61dbe68c72747170774eddb13f533af507a707d19a5d0618c29b8a0"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36fa6d212aa48c45155d1ac6a008fbdcaefe7f17d78e1e0adcda8cdf234c820b"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a40b733c210ba7f5c1db9ea06e2445096fcf616c01b83afe5633948ebd17ec3"
    sha256 cellar: :any_skip_relocation, catalina:      "cd13f1fb4e4b8f405b147e1878af1f8a1bd1496c6444eff219e6814ba9d80f64"
    sha256 cellar: :any_skip_relocation, mojave:        "0f3cc427741abe5a5ad4b5707387f92c7851ef8381c0dd9430dca0a301335aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa468bf7a331273beb5a91060c223274b0ad7922e1f23861ab8976748b5a3939"
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
