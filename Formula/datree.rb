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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301233101d2d4d6cf714f833ecd7579902729030b1e796c037ebe944dd030433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7095fbae116eab2b84b160f43ad42a48689a1423db3f153d16f8bc63586bd05e"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5f0c5da0872b844c7bf82bcbcab94375286496eb6797a6c7880102adb1b156"
    sha256 cellar: :any_skip_relocation, big_sur:        "9331fa4f36c169118953c7880fddc1cd2eac3dff9b85564bc7ba5e6627765457"
    sha256 cellar: :any_skip_relocation, catalina:       "e8bb1990ec927d04c8cc8b80a967690186b32d47bc06e99fdb8c12b0d4a31d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57aab86e8ef326b29431935c9e30ac764e59c24753485db24484f6b5e45c6d8"
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
