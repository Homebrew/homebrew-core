class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "07666f3bb620864b3ad5634d9acfff3c06964ec03c69542e21258c72a4503f40"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d96e16464a24e55ce650de0ec5528fccd2fc2da95a723532bffacfb0dbf7627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d96e16464a24e55ce650de0ec5528fccd2fc2da95a723532bffacfb0dbf7627"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d96e16464a24e55ce650de0ec5528fccd2fc2da95a723532bffacfb0dbf7627"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9ecd7ca50bfb25370259b0bdeecf8de167e3053f4a6fa19cdbc29c28cd0a00"
    sha256 cellar: :any_skip_relocation, monterey:       "9c9ecd7ca50bfb25370259b0bdeecf8de167e3053f4a6fa19cdbc29c28cd0a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c9ecd7ca50bfb25370259b0bdeecf8de167e3053f4a6fa19cdbc29c28cd0a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f4a6ae51b71b24db15d32ac60b97234460bbaa3ddb82714093938fb1f48722"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
  end

  test do
    (testpath/"pod.yaml").write <<~EOS
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
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
