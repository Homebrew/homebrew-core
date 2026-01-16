class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "412a2951851c8a3f279fb99b7d1aebd0b3a6483d1d4a6a2194e24d4859b93c6b"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37abe6a6a742262c59e2ae2e0165c073026931afd60578bdedef4d57819da275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37abe6a6a742262c59e2ae2e0165c073026931afd60578bdedef4d57819da275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37abe6a6a742262c59e2ae2e0165c073026931afd60578bdedef4d57819da275"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b5e53ce6fc39195bece11aa9fd5e75ad0e79fb611d2d8179138b4a401423ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7e80d34785bf009faea778585fad307b80799716a1e58181a3265caa604b2e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "525c4f25f865bd36f427aa7c19f02fcc24bdf56e20f9ac67c1a98be70bd4561f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", shell_parameter_format: :cobra)
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
