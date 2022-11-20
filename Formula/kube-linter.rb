class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.5.0.tar.gz"
  sha256 "448122a7d93239ad55ddc88157ef8c77158e77da792f57faf50b080734295d1b"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e2679ba2dc6b96d306643b992659f7a25eb25751d3bf277bc4ec80b50cfefb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41824152570afe2ee2f5bb16f8e544905328e5b19bc86a143cee6bc4165fef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f41824152570afe2ee2f5bb16f8e544905328e5b19bc86a143cee6bc4165fef7"
    sha256 cellar: :any_skip_relocation, ventura:        "5a814f821c074d1bbd659160fc5cdde841b45668f22bf491834396236d83d3b7"
    sha256 cellar: :any_skip_relocation, monterey:       "6afe851068045910e45c3385d6dcc4a81a0b947d0e1171140d80987faa65f8fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6afe851068045910e45c3385d6dcc4a81a0b947d0e1171140d80987faa65f8fc"
    sha256 cellar: :any_skip_relocation, catalina:       "6afe851068045910e45c3385d6dcc4a81a0b947d0e1171140d80987faa65f8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81286a1e5a642ad94768ba4f8b6eafc237e890f0a586d617719d7cad7a1551ef"
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
