class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.2.tar.gz"
  sha256 "16897c2e419b3ad28a0330113b4a1ed3ad2ced376e0b2e7c7bb92ccb88bfdea5"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b85278302fa410b54bb57509ba76719fca66958f51dbe16ca1dbb55a978a8181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e0533e29be4fec5f3dcf1de025720ba040e0f17e88d5e3596a36caed07e8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a46d318db8249de42f9682b85641c7cc7414949ddb0db891a759a3a02a6a09f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae661c67473ed220721522e013b56aa730275a94e9bb3812745f09bcdc4c871b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4f3c9de2305212091f8182f55dcbf42f3abf40b87dd643d88c6878d3c6b93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef47cf49db79185e1b88b6dbcf21f2a0de30c94550d06ad52e090dfec851eea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}")

    generate_completions_from_executable(bin/"polaris", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polaris version")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              resources: {}
    YAML

    output = shell_output("#{bin}/polaris audit --format=json #{testpath}/deployment.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
