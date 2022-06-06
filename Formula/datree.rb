class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.0.tar.gz"
  sha256 "6fe351177d6799df092cee0180c231dd894b939e5b4bab1aad0447d7dcde8a21"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4622a0a279e7cbd9a72641b002be4673f7eaa005410d17101a5af73790d1c537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b91f49db57fd0644b1d4e807aa8c558c800c0e24a7f69fbcc22fcc02316082f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecae9ac6ad89f02bbe84eed5a3c150e3251b460818ea1cd56a870dde582cc262"
    sha256 cellar: :any_skip_relocation, big_sur:        "8007e48499a90086747d469a5e8051499148b7385587f2b2f2bcd959e0577ba2"
    sha256 cellar: :any_skip_relocation, catalina:       "18a25e568dc8825cd18489384c74595560bc8a6f47f445dbbaa119559637cb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca54faef7d322d6e370029538d595f34fe42658ab5161c1e2ab9253d1cce1625"
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
