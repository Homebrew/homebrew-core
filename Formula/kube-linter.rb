class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.6.0.tar.gz"
  sha256 "7d56831e16f0a883713dbae5d9d83e566d1831e4ace87f99f35c68573cd87e2b"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b4f68b867d5b88a4e73df6c90cd42e7cfdb373e589a286c56fc0ce3846c64e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b4f68b867d5b88a4e73df6c90cd42e7cfdb373e589a286c56fc0ce3846c64e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b4f68b867d5b88a4e73df6c90cd42e7cfdb373e589a286c56fc0ce3846c64e"
    sha256 cellar: :any_skip_relocation, ventura:        "6a8b5fd14a5928416cf5c7fa04dd1ca9739232a13f88a0cc4429da5c788c3143"
    sha256 cellar: :any_skip_relocation, monterey:       "6a8b5fd14a5928416cf5c7fa04dd1ca9739232a13f88a0cc4429da5c788c3143"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8b5fd14a5928416cf5c7fa04dd1ca9739232a13f88a0cc4429da5c788c3143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801e2b579f0c73166e94f6a96df3c225e52aa07ac681221b1fc3097e9a3de76f"
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
