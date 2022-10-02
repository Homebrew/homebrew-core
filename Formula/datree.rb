class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.36.tar.gz"
  sha256 "260f35a25bef2dc2de5a1e96044b935c99922ee72884781bf83d2a335a045d23"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2f33a4e5135ea5701052bb8f1ce19d412587b3ce3f64c2f07634a7cd96c3871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cd2786fb09ef38b8371e61e76f5149df185a58902fbeae07c65906bb27b4c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "bd386584840310d7424af0c3bf0ef02bc293f9d689fe60172ccf0da802476479"
    sha256 cellar: :any_skip_relocation, big_sur:        "470beec6e1c1a24f47c5e3237df45992fcd4400ef197af895a16abeda250d4c4"
    sha256 cellar: :any_skip_relocation, catalina:       "04ff1f750de264b43a81cb353d8565dffc1b0c304feffe4eba17d575bc0c170d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ebf555872b14de109f1e717f8491a48c49b2fb658c0e9474b1ec2e1bd3f4623"
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
