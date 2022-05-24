class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.28.tar.gz"
  sha256 "00b36f21efc5ab713692c1b3e6c8c6447ecd15bd921071796ed9f1d3b1742096"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f878837d513ba201ee43880e1d80b352036a9a4d663ef199c904412e5cddebe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6481d03510422b49a549ca6f8ad095c940b7cd098862ab35cff85f2b5dd9e7de"
    sha256 cellar: :any_skip_relocation, monterey:       "1c11c0448ac463ae1e2b330858490dde0b8dbd5b51c82124f62f288f2c376461"
    sha256 cellar: :any_skip_relocation, big_sur:        "5105d526aac643e79f0dc5e3bda195809631903870d95381ac1727a643b114b7"
    sha256 cellar: :any_skip_relocation, catalina:       "dea010303bc499afc73852221986674452e08c97470fff8857889d8a36cac8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ce3b61414ca07fedf6fa25832250c342e37f1095c2d106ea7ccb51d25f879e"
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
