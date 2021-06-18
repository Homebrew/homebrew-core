class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.2.tar.gz"
  sha256 "5600cf6f0a518073ae8bfa914fd34fd5b9d15aa6316abf21269bcd73870be7c3"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "652544b5dbf19a7b10ace74c2aa17c546ea7c16a6554ccf19c85d9ca6270ac97"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0b84d0e1d7253548e04ac5f26d05eaf844df502622db6c7fa95947765c4f3ce"
    sha256 cellar: :any_skip_relocation, catalina:      "c0b84d0e1d7253548e04ac5f26d05eaf844df502622db6c7fa95947765c4f3ce"
    sha256 cellar: :any_skip_relocation, mojave:        "c0b84d0e1d7253548e04ac5f26d05eaf844df502622db6c7fa95947765c4f3ce"
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
          image: busybox
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
