class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.6.tar.gz"
  sha256 "2fa6a286f2a8563b0b80186e06100f9b00c7698f528bb7ef563b0b508c2d8458"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da57abd7e90a07c623f39219a682fb814970a2c663416b0cef13dbf0dd9a1a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0da57abd7e90a07c623f39219a682fb814970a2c663416b0cef13dbf0dd9a1a4"
    sha256 cellar: :any_skip_relocation, monterey:       "a55cc17a62bd13f124a1076abf621e7f23fa62376669161a31cf6f865b805d42"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55cc17a62bd13f124a1076abf621e7f23fa62376669161a31cf6f865b805d42"
    sha256 cellar: :any_skip_relocation, catalina:       "a55cc17a62bd13f124a1076abf621e7f23fa62376669161a31cf6f865b805d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c6708a201c793dceb47a459f5d93d78f4299c355c46c762233a6e9779e5faf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"
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
