class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.71.tar.gz"
  sha256 "3ed9c89c1675d89b1c3a3963b5a64b8b54e5dea47ac8e1d58cfe84219dbc1002"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2dc0705ca05db88aa013fd275ffd33e6ea24a2867d37c64bd98c2014a3bf5a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87cf03a60f16e7d81cc5824edc2e6bb0dcc1b4a87bb414f6ccefb0662fa17ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "b54f9e77cf0bb17b4b6b320c81b38c95e28ba55f0a5904430eee9b35635a813f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5fa00ccece7dcac797555d40c3357ea53cb42ffd687bee34615f9433c23fce0"
    sha256 cellar: :any_skip_relocation, catalina:       "85f420547843b6388443c9e6a61dd2698b3107201695d8b23b9e225e7fb4b985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9dff14ab74ef491322925d6982c7ec7c19513b782dae710caaa997467fec65"
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
