class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "f85eaae3b622725ef95ee01be4fc9236c09656775935a6b26a21d2dc3daf6af1"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7380829a0f6ae2880c44efe2bf18395b7e1e620b2f2b23fc70516b7063aa7964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7380829a0f6ae2880c44efe2bf18395b7e1e620b2f2b23fc70516b7063aa7964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7380829a0f6ae2880c44efe2bf18395b7e1e620b2f2b23fc70516b7063aa7964"
    sha256 cellar: :any_skip_relocation, sonoma:        "25bbb4d6dd5cce47ca9ad4be319ac607113f2f91bd84841eac7e3fe8420349b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5176ac8d4e627fc465845981de9fd56ee5d8bc11532b472fc2321005b1b81f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790d26121ae92f80f68e5b62ea689276dfc003d6bf7a52c97cf1995020eccb29"
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
