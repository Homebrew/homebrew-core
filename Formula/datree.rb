class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.18.tar.gz"
  sha256 "3fd8a4b0dfb5af00c2c1db67080d218479e5d28c14a824f9bc5b93c086e339c8"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a6f1ff692b1fc55c2a162a9d285200c795cde98069fcaf8b96fb230437f0b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738ee99f8d13aa9d556a4fbdcf960abbbf9e28f7029c09348e24533170a19074"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa02741d2d1017f5646a03cf0ff351ff735c5f7e5e6086c25e8132316bc500f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea8a55e5b925e8473bf8f8b01d10691d65189eda150cb2d8ac387e12a602e2c"
    sha256 cellar: :any_skip_relocation, catalina:       "bfe13adb57f54b63b55eedeb0138112dbb217932ce709e63b2b0709b01f0da0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135aaa9784d34395694b1a98fce44062c4c946c3b0b5d7c514a9a7bf316a10ee"
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
