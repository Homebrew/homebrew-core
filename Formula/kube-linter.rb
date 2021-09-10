class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.3.tar.gz"
  sha256 "420df162c55b7f5d644e50659b4e27bf8cf8d94301fc8bf9464a774f6711100f"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e05ce85b2fb6c0a9982ffe6ea3e00926dc18273ae814d33d6240e8de58e3253"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a5270455df683d4b136efe92056a74c7c52ec45613836adbdb8e7a2fe78975f"
    sha256 cellar: :any_skip_relocation, catalina:      "6a5270455df683d4b136efe92056a74c7c52ec45613836adbdb8e7a2fe78975f"
    sha256 cellar: :any_skip_relocation, mojave:        "6a5270455df683d4b136efe92056a74c7c52ec45613836adbdb8e7a2fe78975f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1acb3e58fe410356fc9f9a6daaf5174970f769e511a76a3ae5742086c5663f"
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
