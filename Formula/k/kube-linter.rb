class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "c0f69e0fa67b27ca84efa180eb398290dfa0d7a7f6f2d1de82a935e0432dd793"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83bab66d3d0155c4c1861234d8830112459c9198dc4bd369a57b8f41abf2a817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bab66d3d0155c4c1861234d8830112459c9198dc4bd369a57b8f41abf2a817"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83bab66d3d0155c4c1861234d8830112459c9198dc4bd369a57b8f41abf2a817"
    sha256 cellar: :any_skip_relocation, sonoma:        "91e2186859aa0fcb75051f90e3039375570aeaa441538fb3e86785beb20937de"
    sha256 cellar: :any_skip_relocation, ventura:       "91e2186859aa0fcb75051f90e3039375570aeaa441538fb3e86785beb20937de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449e2e923903b36730dae87a82861bc751396306ef3778ad3f62ef50ef4a1d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685e907d339ce4a2c86eb03c16d10060e4df345c1e34eeca3f1cff921bcc0565"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
  end

  test do
    (testpath/"pod.yaml").write <<~YAML
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    YAML

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
