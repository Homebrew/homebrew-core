class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "a7a7bb9a94f0677b388375d96857b4a8b6db7be1ab7d6493c44274c0e7397637"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b3a198e71a256fca273cc1804840d6dce1d62aec707eaca5e1b3a9fe565d7fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c0e62e345488c971a9803e2fb92a758ef02fbc7d600487a8cf05b42ee5662f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3a198e71a256fca273cc1804840d6dce1d62aec707eaca5e1b3a9fe565d7fa"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6f1a6de2a589a88d9904b89748592d1394697ff03a79ff7b1991439d14158f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e646085aa3573a08143481d1f517d470e770eec8e0f1e686770711d5a4923bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e646085aa3573a08143481d1f517d470e770eec8e0f1e686770711d5a4923bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8f028f6a4ca84bfa231c29777c066ffb2dcc289f6f46febfc5bc2b7896e040"
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
