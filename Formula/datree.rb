class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.0.tar.gz"
  sha256 "6fcc88911ca79fc5e2aeb164a9391f9566829330a9356c198ebaf7c9c7186739"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848d5328adc6f84409ac32357d0e02efb9f15a9577cc95db5773e7fc35c5ee36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367f9859d526bb458ccd5019a00f4e5abe3c92fab640d59e3ac22cfa97cb7560"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c8ab36b49ad5b9822de8b914cfb50fb57954a8d1fe092f8012d894a897035e"
    sha256 cellar: :any_skip_relocation, ventura:        "9abaeed4be5200a9bf1ea3719fd09e8a29cae66433ff1c8adb9c2b879e7616d2"
    sha256 cellar: :any_skip_relocation, monterey:       "2120e1d36c313dc85f8c8e467cc5117d33bc9fc5a2a4df073eccb10082c8d1ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "c93b0b4341acc9d9bc11cec35ae29383547913f22e4d2566b33d738fc0a2a482"
    sha256 cellar: :any_skip_relocation, catalina:       "fc3ca834df394319d077cc25aa5bc09a2896c53c0fd610ddeada295b83a1da1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e1663ba64073dd2ff80fabd6f3460ed7337195598846ca7396d505fefd3b6a"
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
