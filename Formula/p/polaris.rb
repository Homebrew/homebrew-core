class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.3.tar.gz"
  sha256 "eaa15224739aea756f67ae84a2e086ec1f6716539245ed37572c064d3d598f46"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e66e333ef34f15f0fac95c5cb9bfa7a9b8cb2c7db6863379a76ee9950016d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167814c97e317e1be2e5555d9db90903bc4834b1722c8e1de385860687560912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113274a42105d150669a2345d6b6a37df314a66220d5ed6464d4dbba907fc890"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e27f90794d815758125f73ab8502f228b8733627cd6089fb5955a3e7f2e891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beaed4cd959e08e554f1f5060e067b1f1c05908c7350c8fc0dd37a7d24589214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892f3ea7d3cb7143d9bfe8bf7aec1b3d2c6f2586cf4e64cbfd33513b30be562f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"polaris", shell_parameter_format: :cobra)
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
