class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.26.tar.gz"
  sha256 "898fe09f108cc4d79675236152a7082f2c635d886e9cc2cd170ac54db0e5bad1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd1f34df0d1195b14239a3731bd655402d5a8804a687f2eaa2e91b9aaaecedc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f47976e4c8fae9fa330a21948b6d224b4fb32b88e8500d00753cb63348562583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be9820ae84a8f04b20881d6ecf8ddd823a625f31e6ff386df5416f79d5067c72"
    sha256 cellar: :any_skip_relocation, ventura:        "2b1d31ebda332facd749109432685ca35ccdeaa629ced6e118bb934dbbb3880f"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd4c268ec30127476449193d0f3b7abec18cbe402e0e3dcf6b9c3b31cc6c8de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3cf3d51060acc7040fb09c1f3234a06b4d953d22ae958975d11ce4d33729d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ecced214e8ce80759729e8c0da6086628ed71aed1e7d39e55410ca14b62dd5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
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
