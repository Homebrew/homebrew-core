class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.51.tar.gz"
  sha256 "896314e977cddabe6d382a677d90b2ad10a7aa4d4542df9de8f4b6004ae62214"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a18cefbad7f05384ac1029b7cbb2cebaeeb5beeb6e7839f3b82440fdbbf29d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "864522e8e64faed6375c70db09c7d826681b764362c12994986b305f6ad2b0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "892f43e06d4024104311e2d98b3c8ab3c2969101f9caa1f55ce059f7c1cae055"
    sha256 cellar: :any_skip_relocation, ventura:        "a0bfb9194523c50321d1ac9ec00e730f7dcc0d57f4adbb0512a1a2643396086b"
    sha256 cellar: :any_skip_relocation, monterey:       "f90f548fc7512d2657369f01345834ace7691ae51ccef43eb11a65777a396d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c332fad07c266316a005be6621e35d338133b355cf48684ea56425499c009ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc3bb2fbf072cddd32f83ceea4b62091f0c6706f5b695a089cf9398a38ed5dd"
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
