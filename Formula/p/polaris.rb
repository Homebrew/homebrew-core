class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.8.tar.gz"
  sha256 "d141addc407163aeaa09239b5bf1a93beccaee58fb339c7ff24e4ad3e75a547d"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb5926abae97f46d9ee01a68b5257ba6671b5213f030ba8ae55b86b5a434869c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55bef6c248fd6e3ca9bb13123bdd9b31f1ec0193b5e0eaaa3a5d4099b22c2511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d115084cf7e9d9458668d73f8761baa7f79a189b27fa2e6be7041542a2fed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b187b626ee56d246725cab4f42510de5c6a0a2a7ec2bbc620a7a8286e9d3d0ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4105111355b79731189c08a54fca1e80fcbe045e842665ef411f394d09ed898b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce36caff7ee2767d340b387d0fc21fc3865f551f37ad15e52aeb914e021dabc7"
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
