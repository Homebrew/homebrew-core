class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "f80ae1293194ef22f1e012f0e5fd031e0dcbf48f16ad70888664b5608c4f3459"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26bbd31156e7858148b233b12453bbbc09595a437290c171ed9fa68e43001e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67bd23db10733c8b6e871585f67f95f7f3ee49aa2c8b4aa92f099fccb82c1bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e5f36854a4f3070b7aed628755d948e6f520cf2ce2bf4abcb5a2f0c80319581"
    sha256 cellar: :any_skip_relocation, sonoma:        "da29247daaf347fd5a713f893105221bea134ab136e1fddb0976b496ab991d9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cada1685696db750fa39dcee9dfe4258173bbe80e9f214fd733449618c84e6f2"
    sha256 cellar: :any,                 x86_64_linux:  "85f73712f0caad69fcd5d5903cd4b45cc50cb072a8cc8e112482b0ce5567da93"
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
