class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.9.4.tar.gz"
  sha256 "8bcc5d0e2d757de628d5ed5fa4ece72facb1a461f46d7daab1d34ada6c86c89e"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74595b9f8fdb289ca06ed4ab9f0304389ee138272a789dfd497fdef8e3690f4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3294f385794628f4c2d54d768fb3612a6a0c8b6bbff92b8cf5777594b77007d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df0252d9fd3164f1b9c2d82dccd14ce789de4824ab58009f4f8e78b22ea11ee7"
    sha256 cellar: :any_skip_relocation, ventura:        "d561cfa95812f10a4db714404d81cd5faeba244205f260a2193b52c90d55bd32"
    sha256 cellar: :any_skip_relocation, monterey:       "a0dc152b48e27a9151f3a304413c57f44978f489626ec53867156b8e79f7c5e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecd4addb4b492dfef47c3228ecbcf4526c9fdeae4661d52754a6d014590bcdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4c9caa6b5b525c9a54b1b3ddf1b7ba07e67e7a52acea3cd0bec1161706e94b"
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
