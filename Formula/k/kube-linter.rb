class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "4eddda7b150883fb23164f3359eb26403ef66aa5848ee7748db5fb60fadf9062"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff603e8babc039933d721f842eb20e67873b56721176622afc008631eef67c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff603e8babc039933d721f842eb20e67873b56721176622afc008631eef67c6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff603e8babc039933d721f842eb20e67873b56721176622afc008631eef67c6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6638781c3a64265db28fd3fdfed57c17feca8931c8118648b8e4901ce556f168"
    sha256 cellar: :any_skip_relocation, ventura:        "6638781c3a64265db28fd3fdfed57c17feca8931c8118648b8e4901ce556f168"
    sha256 cellar: :any_skip_relocation, monterey:       "6638781c3a64265db28fd3fdfed57c17feca8931c8118648b8e4901ce556f168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85065f48fb2e7cfad72e95a2be2d1712efa2af57cfb8b427ad8226355b9041fc"
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
